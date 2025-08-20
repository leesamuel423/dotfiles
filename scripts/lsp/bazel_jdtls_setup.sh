#!/bin/bash
# Generic script to set up JDTLS for any Bazel Java project
# Usage: ./bazel_jdtls_setup.sh [project_root]

PROJECT_ROOT="${1:-.}"
cd "$PROJECT_ROOT" || exit 1

echo "Setting up JDTLS for Bazel project in: $(pwd)"

# Create .project file if it doesn't exist
if [ ! -f .project ]; then
    PROJECT_NAME=$(basename "$(pwd)")
    cat > .project << EOF
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>$PROJECT_NAME</name>
	<comment></comment>
	<projects>
	</projects>
	<buildSpec>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>
EOF
    echo "Created .project file"
fi

# Find Bazel cache directory
BAZEL_OUTPUT=$(bazel info output_base 2>/dev/null)
if [ -z "$BAZEL_OUTPUT" ]; then
    echo "Error: Could not determine Bazel output directory"
    echo "Make sure you're in a Bazel workspace with WORKSPACE or MODULE.bazel file"
    exit 1
fi

# Try to build Java targets to ensure dependencies are fetched
echo "Fetching dependencies (this may take a moment)..."
if [ -d "java" ]; then
    bazel build //java/... 2>/dev/null || true
else
    # Try to find any Java targets
    bazel query 'kind("java_library|java_binary|java_test", //...)' 2>/dev/null | head -5 | xargs bazel build 2>/dev/null || true
fi

# Find common Java test dependencies
JUNIT4_JAR=$(find "$BAZEL_OUTPUT/external" -name "junit-4.*.jar" 2>/dev/null | head -1)
JUNIT5_JAR=$(find "$BAZEL_OUTPUT/external" -name "junit-jupiter-*.jar" 2>/dev/null | head -1)
HAMCREST_JAR=$(find "$BAZEL_OUTPUT/external" -name "hamcrest-core-*.jar" 2>/dev/null | head -1)
MOCKITO_JAR=$(find "$BAZEL_OUTPUT/external" -name "mockito-core-*.jar" 2>/dev/null | head -1)
ASSERTJ_JAR=$(find "$BAZEL_OUTPUT/external" -name "assertj-core-*.jar" 2>/dev/null | head -1)

# Generate .classpath file
cat > .classpath << EOF
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
EOF

# Add source directories - look for directories containing .java files
echo "Finding Java source directories..."
if [ -d "src" ]; then
    # Standard src layout
    find src -type d -name "java" | while read -r dir; do
        echo "	<classpathentry kind=\"src\" path=\"$dir\"/>" >> .classpath
    done
    find src -type d -name "test" | while read -r dir; do
        echo "	<classpathentry kind=\"src\" path=\"$dir\"/>" >> .classpath
    done
fi

# Check for java/ directory structure (like algo-grind)
if [ -d "java" ]; then
    # Add each subdirectory as a source path
    for dir in java/*/; do
        if [ -d "$dir" ] && ls "$dir"*.java >/dev/null 2>&1; then
            echo "	<classpathentry kind=\"src\" path=\"${dir%/}\"/>" >> .classpath
        fi
    done
fi

# Look for other common patterns
for pattern in "*/src/main/java" "*/src/test/java" "src/main/java" "src/test/java"; do
    for dir in $pattern; do
        if [ -d "$dir" ]; then
            echo "	<classpathentry kind=\"src\" path=\"$dir\"/>" >> .classpath
        fi
    done
done

# Add JRE container
cat >> .classpath << EOF
	<classpathentry kind=\"con\" path=\"org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-17\"/>
EOF

# Add found libraries
[ -n "$JUNIT4_JAR" ] && echo "	<classpathentry kind=\"lib\" path=\"$JUNIT4_JAR\"/>" >> .classpath
[ -n "$JUNIT5_JAR" ] && echo "	<classpathentry kind=\"lib\" path=\"$JUNIT5_JAR\"/>" >> .classpath
[ -n "$HAMCREST_JAR" ] && echo "	<classpathentry kind=\"lib\" path=\"$HAMCREST_JAR\"/>" >> .classpath
[ -n "$MOCKITO_JAR" ] && echo "	<classpathentry kind=\"lib\" path=\"$MOCKITO_JAR\"/>" >> .classpath
[ -n "$ASSERTJ_JAR" ] && echo "	<classpathentry kind=\"lib\" path=\"$ASSERTJ_JAR\"/>" >> .classpath

# Add any other JARs from external (be selective to avoid too many)
find "$BAZEL_OUTPUT/external" -maxdepth 4 -name "*.jar" 2>/dev/null | grep -E "(guava|commons|slf4j|log4j)" | head -10 | while read -r jar; do
    echo "	<classpathentry kind=\"lib\" path=\"$jar\"/>" >> .classpath
done

# Close classpath
cat >> .classpath << EOF
	<classpathentry kind=\"output\" path=\"bazel-bin\"/>
</classpath>
EOF

# Report what was configured
echo "✓ Generated .classpath with:"
[ -n "$JUNIT4_JAR" ] && echo "  - JUnit 4: $(basename "$JUNIT4_JAR")"
[ -n "$JUNIT5_JAR" ] && echo "  - JUnit 5: $(basename "$JUNIT5_JAR")"
[ -n "$HAMCREST_JAR" ] && echo "  - Hamcrest: $(basename "$HAMCREST_JAR")"
[ -n "$MOCKITO_JAR" ] && echo "  - Mockito: $(basename "$MOCKITO_JAR")"
[ -n "$ASSERTJ_JAR" ] && echo "  - AssertJ: $(basename "$ASSERTJ_JAR")"
echo "  - Source directories: $(grep -c 'kind="src"' .classpath)"

echo ""
echo "✓ JDTLS setup complete!"
echo "  Restart Neovim and open a Java file to activate JDTLS"
echo ""
echo "Note: If dependencies change, re-run this script to update the classpath"
