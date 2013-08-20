From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 3/3] cifs: add winucase_convert.pl to Documentation/ directory
Date: Tue, 20 Aug 2013 15:50:11 -0400
Message-ID: <1377028211-17624-4-git-send-email-jlayton@redhat.com>
References: <1377028211-17624-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	glogow@fbihome.de, bj@sernet.de
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1377028211-17624-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Add the script used to generate the case-conversion tables to the
Documentation/ directory, in case we ever need to update or regenerate
these tables in the future.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 Documentation/filesystems/cifs/winucase_convert.pl | 62 ++++++++++++++++++++++
 1 file changed, 62 insertions(+)
 create mode 100755 Documentation/filesystems/cifs/winucase_convert.pl

diff --git a/Documentation/filesystems/cifs/winucase_convert.pl b/Documentation/filesystems/cifs/winucase_convert.pl
new file mode 100755
index 0000000..322a9c8
--- /dev/null
+++ b/Documentation/filesystems/cifs/winucase_convert.pl
@@ -0,0 +1,62 @@
+#!/usr/bin/perl -w
+#
+# winucase_convert.pl -- convert "Windows 8 Upper Case Mapping Table.txt" to
+#                        a two-level set of C arrays.
+#
+#   Copyright 2013: Jeff Layton <jlayton@redhat.com>
+#
+#   This program is free software: you can redistribute it and/or modify
+#   it under the terms of the GNU General Public License as published by
+#   the Free Software Foundation, either version 3 of the License, or
+#   (at your option) any later version.
+#
+#   This program is distributed in the hope that it will be useful,
+#   but WITHOUT ANY WARRANTY; without even the implied warranty of
+#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#   GNU General Public License for more details.
+#
+#   You should have received a copy of the GNU General Public License
+#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
+#
+
+while(<>) {
+	next if (!/^0x(..)(..)\t0x(....)\t/);
+	$firstchar = hex($1);
+	$secondchar = hex($2);
+	$uppercase = hex($3);
+
+	$top[$firstchar][$secondchar] = $uppercase;
+}
+
+for ($i = 0; $i < 256; $i++) {
+	next if (!$top[$i]);
+
+	printf("static const wchar_t t2_%2.2x[256] = {", $i);
+	for ($j = 0; $j < 256; $j++) {
+		if (($j % 8) == 0) {
+			print "\n\t";
+		} else {
+			print " ";
+		}
+		printf("0x%4.4x,", $top[$i][$j] ? $top[$i][$j] : 0);
+	}
+	print "\n};\n\n";
+}
+
+printf("static const wchar_t *const toplevel[256] = {", $i);
+for ($i = 0; $i < 256; $i++) {
+	if (($i % 8) == 0) {
+		print "\n\t";
+	} elsif ($top[$i]) {
+		print " ";
+	} else {
+		print "  ";
+	}
+
+	if ($top[$i]) {
+		printf("t2_%2.2x,", $i);
+	} else {
+		print "NULL,";
+	}
+}
+print "\n};\n\n";
-- 
1.8.3.1

