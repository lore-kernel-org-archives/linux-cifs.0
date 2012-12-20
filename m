From: Jeff Layton <jlayton@samba.org>
Subject: [PATCH v3 6/6] cifs-utils: add a manpage for idmapwb
Date: Thu, 20 Dec 2012 07:50:33 -0500
Message-ID: <1356007833-10893-7-git-send-email-jlayton@samba.org>
References: <1356007833-10893-1-git-send-email-jlayton@samba.org>
Cc: samba-technical@lists.samba.org
To: linux-cifs@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1356007833-10893-1-git-send-email-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

...and clean up references to winbind in various tool manpages.

Signed-off-by: Jeff Layton <jlayton@samba.org>
---
 Makefile.am     |  21 +++++++-
 cifs.idmap.8.in |  22 ++++-----
 configure.ac    |   1 +
 getcifsacl.1    |  58 ----------------------
 getcifsacl.1.in |  59 ++++++++++++++++++++++
 idmapwb.8.in    | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 idmapwb.pod     |  26 ++++++++++
 setcifsacl.1    | 111 ------------------------------------------
 setcifsacl.1.in | 113 ++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 376 insertions(+), 183 deletions(-)
 delete mode 100644 getcifsacl.1
 create mode 100644 getcifsacl.1.in
 create mode 100644 idmapwb.8.in
 create mode 100644 idmapwb.pod
 delete mode 100644 setcifsacl.1
 create mode 100644 setcifsacl.1.in

diff --git a/Makefile.am b/Makefile.am
index 8836b47..6407520 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -11,7 +11,7 @@ include_HEADERS = cifsidmap.h
 
 bin_PROGRAMS =
 sbin_PROGRAMS =
-clean-local: clean-local-upcall clean-local-idmap
+clean-local: clean-local-upcall clean-local-idmap clean-local-cifsacl
 
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS += cifs.upcall
@@ -46,7 +46,7 @@ cifs_idmap_LDADD = -lkeyutils -ldl
 man_MANS += cifs.idmap.8
 
 cifs.idmap.8: cifs.idmap.8.in
-	$(SED) 's,[@]sbindir@,$(sbindir),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+	$(SED) -e 's,[@]sbindir@,$(sbindir),' -e 's,[@]pluginpath@,$(pluginpath),' $(srcdir)/$@.in > $@-t && mv $@-t $@
 endif
 
 clean-local-idmap:
@@ -60,18 +60,35 @@ getcifsacl_SOURCES = getcifsacl.c idmap_plugin.c
 getcifsacl_LDADD = -ldl
 man_MANS += getcifsacl.1
 
+getcifsacl.1: getcifsacl.1.in
+	$(SED) 's,[@]pluginpath@,$(pluginpath),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+
 bin_PROGRAMS += setcifsacl
 setcifsacl_SOURCES = setcifsacl.c idmap_plugin.c
 setcifsacl_LDADD = -ldl
 man_MANS += setcifsacl.1
+
+setcifsacl.1: setcifsacl.1.in
+	$(SED) 's,[@]pluginpath@,$(pluginpath),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+endif
+
+clean-local-cifsacl:
+if CONFIG_CIFSACL
+	rm -f getcifsacl.1 getcifsacl.1-t
+	rm -f setcifsacl.1 setcifsacl.1-t
 endif
 
 if CONFIG_PLUGIN
 plugindir = $(pkglibdir)
 plugin_PROGRAMS = idmapwb.so
+man_MANS += idmapwb.8
 
 idmapwb.so: idmapwb.c
 	$(CC) $(CFLAGS) $(AM_CFLAGS) $(WBCLIENT_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ $(WBCLIENT_LIBS)
+
+idmapwb.8: idmapwb.8.in
+	$(SED) 's,[@]pluginpath@,$(pluginpath),' $(srcdir)/$@.in > $@-t && mv $@-t $@
+
 endif
 
 SUBDIRS = contrib
diff --git a/cifs.idmap.8.in b/cifs.idmap.8.in
index c022402..07863ba 100644
--- a/cifs.idmap.8.in
+++ b/cifs.idmap.8.in
@@ -32,18 +32,16 @@ cifs\&.idmap is a userspace helper program for the linux CIFS client filesystem\
 cifs\&.idmap is generally intended to be run when the kernel calls request\-key(8)
 for a particular key type\&. While it can be run directly from the command\-line, it is not generally intended to be run that way\&.
 .PP
-cifs\&.idmap works in conjuction with winbind facility of Samba suite to map owner and group SIDs to uids and gids respectively\&.  It is best utilized when
-.br
-\t\- a mount option of cifsacl is specified when mounting a cifs share
-.br
-\t\- winbind is specified as one of the search entries for passwd and group databases in file /etc/nsswitch\&.conf
-.br
-\t\- file smb.conf has winbind specific entries
-.br
-\t\- winbind daemon program is running
-.br
-.sp
-In case winbind and cifs.idmap facilities are unavailable, file objects in a mounted share are assigned uid and gid of the credentials of the process that mounted the share\&. So it is strongly recomemended to use mount options of uid and gid to specify a default uid and gid to map owner SIDs and group SIDs respectively in case services of winbind and cifs.idmap facility are unavailable\&.
+This program is only called if a share is mounted with the \fBcifsacl\fR mount
+option. The kernel will only upcall to do this conversion if that mount option
+is specified.
+.PP
+cifs.idmap relies on a plugin to handle the ID mapping. If it can't find the
+plugin then it will not work properly. The plugin (or a symlink to it) must be
+at \fB@pluginpath@\fR.
+.PP
+In the case where cifs.idmap or the plugin are unavailable, file objects in a mounted share are assigned uid and gid of the credentials of the process that mounted the share\&. It is strongly recomemended to use mount options of uid and gid to specify a default uid and gid to map owner SIDs and group SIDs in this
+situation.
 .SH "OPTIONS"
 .PP
 --help|-h
diff --git a/configure.ac b/configure.ac
index 209bff2..0653f16 100644
--- a/configure.ac
+++ b/configure.ac
@@ -59,6 +59,7 @@ AC_ARG_WITH(idmap-plugin,
 	pluginpath=$withval,
 	pluginpath="/etc/cifs-utils/idmap-plugin")
 AC_DEFINE_UNQUOTED(IDMAP_PLUGIN_PATH, "$pluginpath", [Location of plugin that ID mapping infrastructure should use. (usually a symlink to real plugin)])
+AC_SUBST([pluginpath])
 
 # check for ROOTSBINDIR environment var
 if test -z $ROOTSBINDIR; then
diff --git a/getcifsacl.1 b/getcifsacl.1
deleted file mode 100644
index ef0a296..0000000
--- a/getcifsacl.1
+++ /dev/null
@@ -1,58 +0,0 @@
-'\" t
-.\"     Title: cifs.idmap
-.\"    Author: [see the "AUTHOR" section]
-.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
-.\"      Date: 08/19/2011
-.\"    Manual: System Administration tools
-.\"    Source: cifs-utils 4.0
-.\"  Language: English
-.\"
-.TH "GETCIFSACL" "1" "08/19/2011" "cifs-utils" "CIFS Access Control List Tools"
-.\" -----------------------------------------------------------------
-.\" * set default formatting
-.\" -----------------------------------------------------------------
-.\" disable hyphenation
-.nh
-.\" disable justification (adjust text to left margin only)
-.ad l
-.\" -----------------------------------------------------------------
-.\" * MAIN CONTENT STARTS HERE *
-.\" -----------------------------------------------------------------
-.SH "NAME"
-getcifsacl \- Userspace helper to display an ACL in a security descriptor for Common Internet File System (CIFS)
-.SH "SYNOPSIS"
-.HP \w'\ 'u
-getcifsacl [\-v|\-r] {file system object}
-.SH "DESCRIPTION"
-.PP
-This tool is part of the cifs-utils suite\&.
-.PP
-getcifsacl is a userspace helper program for the Linux CIFS client file system.  It is intended to display a security descriptor including ACL for a file system object.  It is best utilized when an option of cifsacl is specified when mounting a cifs share in conjunction with winbind facility of Samba suite.
-.PP
-Fields of an ACE such as SID, type, flags, and mask are displayed separated by /.  Numeric values of type, flags, and mask are displayed in hexadecimal format.
-.SH "OPTIONS"
-.PP
-\-v
-.RS 4
-Print version number and exit\&.
-.RE
-\-r
-.RS 4
-Display a security descriptor in raw mode. Values such as type and flags are displayed in hexadecimal format, a SID is not mapped to a name.
-.RE
-.SH "NOTES"
-.PP
-Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
-.SH "SEE ALSO"
-.PP
-\fBmount.cifs\fR(8),
-\fBwinbindd\fR(8),
-\fBsetcifsacl\fR(1)
-.PP
-.SH "AUTHOR"
-.PP
-Shirish Pargaonkar wrote the getcifsacl program\&.
-.PP
-The
-Linux CIFS Mailing list
-is the preferred place to ask questions regarding these programs\&.
diff --git a/getcifsacl.1.in b/getcifsacl.1.in
new file mode 100644
index 0000000..fa09dc3
--- /dev/null
+++ b/getcifsacl.1.in
@@ -0,0 +1,59 @@
+'\" t
+.\"     Title: cifs.idmap
+.\"    Author: [see the "AUTHOR" section]
+.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
+.\"      Date: 08/19/2011
+.\"    Manual: System Administration tools
+.\"    Source: cifs-utils 4.0
+.\"  Language: English
+.\"
+.TH "GETCIFSACL" "1" "08/19/2011" "cifs-utils" "CIFS Access Control List Tools"
+.\" -----------------------------------------------------------------
+.\" * set default formatting
+.\" -----------------------------------------------------------------
+.\" disable hyphenation
+.nh
+.\" disable justification (adjust text to left margin only)
+.ad l
+.\" -----------------------------------------------------------------
+.\" * MAIN CONTENT STARTS HERE *
+.\" -----------------------------------------------------------------
+.SH "NAME"
+getcifsacl \- Userspace helper to display an ACL in a security descriptor for Common Internet File System (CIFS)
+.SH "SYNOPSIS"
+.HP \w'\ 'u
+getcifsacl [\-v|\-r] {file system object}
+.SH "DESCRIPTION"
+.PP
+This tool is part of the cifs-utils suite\&.
+.PP
+getcifsacl is a userspace helper program for the Linux CIFS client file system. It is intended to display a security descriptor including ACL for a file system object.
+.PP
+This program uses a plugin to handle the mapping of SIDs to user and group names. \fB@pluginpath@\fR should be a symlink that points to the correct plugin to use.
+.PP
+Fields of an ACE such as SID, type, flags, and mask are displayed separated by /.  Numeric values of type, flags, and mask are displayed in hexadecimal format.
+.SH "OPTIONS"
+.PP
+\-v
+.RS 4
+Print version number and exit\&.
+.RE
+\-r
+.RS 4
+Display a security descriptor in raw mode. Values such as type and flags are displayed in hexadecimal format, a SID is not mapped to a name.
+.RE
+.SH "NOTES"
+.PP
+Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
+.SH "SEE ALSO"
+.PP
+\fBmount.cifs\fR(8),
+\fBsetcifsacl\fR(1)
+.PP
+.SH "AUTHOR"
+.PP
+Shirish Pargaonkar wrote the getcifsacl program\&.
+.PP
+The
+Linux CIFS Mailing list
+is the preferred place to ask questions regarding these programs\&.
diff --git a/idmapwb.8.in b/idmapwb.8.in
new file mode 100644
index 0000000..ef6bf03
--- /dev/null
+++ b/idmapwb.8.in
@@ -0,0 +1,148 @@
+.\" Automatically generated by Pod::Man 2.25 (Pod::Simple 3.16)
+.\"
+.\" Standard preamble:
+.\" ========================================================================
+.de Sp \" Vertical space (when we can't use .PP)
+.if t .sp .5v
+.if n .sp
+..
+.de Vb \" Begin verbatim text
+.ft CW
+.nf
+.ne \\$1
+..
+.de Ve \" End verbatim text
+.ft R
+.fi
+..
+.\" Set up some character translations and predefined strings.  \*(-- will
+.\" give an unbreakable dash, \*(PI will give pi, \*(L" will give a left
+.\" double quote, and \*(R" will give a right double quote.  \*(C+ will
+.\" give a nicer C++.  Capital omega is used to do unbreakable dashes and
+.\" therefore won't be available.  \*(C` and \*(C' expand to `' in nroff,
+.\" nothing in troff, for use with C<>.
+.tr \(*W-
+.ds C+ C\v'-.1v'\h'-1p'\s-2+\h'-1p'+\s0\v'.1v'\h'-1p'
+.ie n \{\
+.    ds -- \(*W-
+.    ds PI pi
+.    if (\n(.H=4u)&(1m=24u) .ds -- \(*W\h'-12u'\(*W\h'-12u'-\" diablo 10 pitch
+.    if (\n(.H=4u)&(1m=20u) .ds -- \(*W\h'-12u'\(*W\h'-8u'-\"  diablo 12 pitch
+.    ds L" ""
+.    ds R" ""
+.    ds C` ""
+.    ds C' ""
+'br\}
+.el\{\
+.    ds -- \|\(em\|
+.    ds PI \(*p
+.    ds L" ``
+.    ds R" ''
+'br\}
+.\"
+.\" Escape single quotes in literal strings from groff's Unicode transform.
+.ie \n(.g .ds Aq \(aq
+.el       .ds Aq '
+.\"
+.\" If the F register is turned on, we'll generate index entries on stderr for
+.\" titles (.TH), headers (.SH), subsections (.SS), items (.Ip), and index
+.\" entries marked with X<> in POD.  Of course, you'll have to process the
+.\" output yourself in some meaningful fashion.
+.ie \nF \{\
+.    de IX
+.    tm Index:\\$1\t\\n%\t"\\$2"
+..
+.    nr % 0
+.    rr F
+.\}
+.el \{\
+.    de IX
+..
+.\}
+.\"
+.\" Accent mark definitions (@(#)ms.acc 1.5 88/02/08 SMI; from UCB 4.2).
+.\" Fear.  Run.  Save yourself.  No user-serviceable parts.
+.    \" fudge factors for nroff and troff
+.if n \{\
+.    ds #H 0
+.    ds #V .8m
+.    ds #F .3m
+.    ds #[ \f1
+.    ds #] \fP
+.\}
+.if t \{\
+.    ds #H ((1u-(\\\\n(.fu%2u))*.13m)
+.    ds #V .6m
+.    ds #F 0
+.    ds #[ \&
+.    ds #] \&
+.\}
+.    \" simple accents for nroff and troff
+.if n \{\
+.    ds ' \&
+.    ds ` \&
+.    ds ^ \&
+.    ds , \&
+.    ds ~ ~
+.    ds /
+.\}
+.if t \{\
+.    ds ' \\k:\h'-(\\n(.wu*8/10-\*(#H)'\'\h"|\\n:u"
+.    ds ` \\k:\h'-(\\n(.wu*8/10-\*(#H)'\`\h'|\\n:u'
+.    ds ^ \\k:\h'-(\\n(.wu*10/11-\*(#H)'^\h'|\\n:u'
+.    ds , \\k:\h'-(\\n(.wu*8/10)',\h'|\\n:u'
+.    ds ~ \\k:\h'-(\\n(.wu-\*(#H-.1m)'~\h'|\\n:u'
+.    ds / \\k:\h'-(\\n(.wu*8/10-\*(#H)'\z\(sl\h'|\\n:u'
+.\}
+.    \" troff and (daisy-wheel) nroff accents
+.ds : \\k:\h'-(\\n(.wu*8/10-\*(#H+.1m+\*(#F)'\v'-\*(#V'\z.\h'.2m+\*(#F'.\h'|\\n:u'\v'\*(#V'
+.ds 8 \h'\*(#H'\(*b\h'-\*(#H'
+.ds o \\k:\h'-(\\n(.wu+\w'\(de'u-\*(#H)/2u'\v'-.3n'\*(#[\z\(de\v'.3n'\h'|\\n:u'\*(#]
+.ds d- \h'\*(#H'\(pd\h'-\w'~'u'\v'-.25m'\f2\(hy\fP\v'.25m'\h'-\*(#H'
+.ds D- D\\k:\h'-\w'D'u'\v'-.11m'\z\(hy\v'.11m'\h'|\\n:u'
+.ds th \*(#[\v'.3m'\s+1I\s-1\v'-.3m'\h'-(\w'I'u*2/3)'\s-1o\s+1\*(#]
+.ds Th \*(#[\s+2I\s-2\h'-\w'I'u*3/5'\v'-.3m'o\v'.3m'\*(#]
+.ds ae a\h'-(\w'a'u*4/10)'e
+.ds Ae A\h'-(\w'A'u*4/10)'E
+.    \" corrections for vroff
+.if v .ds ~ \\k:\h'-(\\n(.wu*9/10-\*(#H)'\s-2\u~\d\s+2\h'|\\n:u'
+.if v .ds ^ \\k:\h'-(\\n(.wu*10/11-\*(#H)'\v'-.4m'^\v'.4m'\h'|\\n:u'
+.    \" for low resolution devices (crt and lpr)
+.if \n(.H>23 .if \n(.V>19 \
+\{\
+.    ds : e
+.    ds 8 ss
+.    ds o a
+.    ds d- d\h'-1'\(ga
+.    ds D- D\h'-1'\(hy
+.    ds th \o'bp'
+.    ds Th \o'LP'
+.    ds ae ae
+.    ds Ae AE
+.\}
+.rm #[ #] #H #V #F C
+.\" ========================================================================
+.\"
+.IX Title "IDMAPWB 8"
+.TH IDMAPWB 8 "2012-12-17" "" ""
+.\" For nroff, turn off justification.  Always turn off hyphenation; it makes
+.\" way too many mistakes in technical documents.
+.if n .ad l
+.nh
+.SH "NAME"
+idmapwb.so \- winbind ID mapping plugin for cifs\-utils
+.SH "DESCRIPTION"
+.IX Header "DESCRIPTION"
+This plugin allows the utilities in cifs-utils to work in conjuction with
+the winbind facility of Samba suite. It handles several functions including
+mapping \s-1UID\s0 and \s-1GID\s0 to SIDs and vice versa.
+.PP
+Utilities are usually configured to use the correct plugin by creating a
+symlink at \f(CW@pluginpath\fR@ that points to the correct plugin that you wish
+to use.
+.PP
+This plugin requires that \fB\f(BIwinbindd\fB\|(8)\fR be properly configured and running.
+.SH "SEE ALSO \fIgetcifsacl\fP\|(1), \fIsetcifsacl\fP\|(1), \fIcifs.idmap\fP\|(8), \fIsamba\fP\|(7), \fIsmb.conf\fP\|(5), \fIwinbindd\fP\|(8)"
+.IX Header "SEE ALSO getcifsacl, setcifsacl, cifs.idmap, samba, smb.conf, winbindd"
+.SH "AUTHOR idmapwb.so was written by Jeff Layton <jlayton@samba.org>"
+.IX Header "AUTHOR idmapwb.so was written by Jeff Layton <jlayton@samba.org>"
diff --git a/idmapwb.pod b/idmapwb.pod
new file mode 100644
index 0000000..4cc2b5a
--- /dev/null
+++ b/idmapwb.pod
@@ -0,0 +1,26 @@
+# turn into a manpage with the following command:
+#
+# pod2man -s 8 -c '' -r '' --stderr idmapwb.pod > idmapwb.8.in
+#
+
+=head1 NAME
+
+idmapwb.so - winbind ID mapping plugin for cifs-utils
+
+=head1 DESCRIPTION
+
+This plugin allows the utilities in cifs-utils to work in conjuction with
+the winbind facility of Samba suite. It handles several functions including
+mapping UID and GID to SIDs and vice versa.
+
+Utilities are usually configured to use the correct plugin by creating a
+symlink at @pluginpath@ that points to the correct plugin that you wish
+to use.
+
+This plugin requires that B<winbindd(8)> be properly configured and running.
+
+=head1 SEE ALSO
+getcifsacl(1), setcifsacl(1), cifs.idmap(8), samba(7), smb.conf(5), winbindd(8)
+
+=head1 AUTHOR
+idmapwb.so was written by Jeff Layton <jlayton@samba.org>
diff --git a/setcifsacl.1 b/setcifsacl.1
deleted file mode 100644
index 3dd755c..0000000
--- a/setcifsacl.1
+++ /dev/null
@@ -1,111 +0,0 @@
-'\" t
-.\"     Title: cifs.idmap
-.\"    Author: [see the "AUTHOR" section]
-.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
-.\"      Date: 08/19/2011
-.\"    Manual: System Administration tools
-.\"    Source: cifs-utils 4.0
-.\"  Language: English
-.\"
-.TH "SETCIFSACL" "1" "08/19/2011" "cifs-utils" "CIFS Access Control List Tools"
-.\" -----------------------------------------------------------------
-.\" * set default formatting
-.\" -----------------------------------------------------------------
-.\" disable hyphenation
-.nh
-.\" disable justification (adjust text to left margin only)
-.ad l
-.\" -----------------------------------------------------------------
-.\" * MAIN CONTENT STARTS HERE *
-.\" -----------------------------------------------------------------
-.SH "NAME"
-setcifsacl \- Userspace helper to alter an ACL in a security descriptor for Common Internet File System (CIFS)
-.SH "SYNOPSIS"
-.HP \w'\ 'u
-setcifsacl [\-v|\-a|\-D|\-M|\-S] "{one or more ACEs}" {file system object}
-.SH "DESCRIPTION"
-.PP
-This tool is part of the cifs-utils suite\&.
-.PP
-setcifsacl is a userspace helper program for the Linux CIFS client file system.  It is intended to alter an ACL of a security descriptor for a file system object.  It is best utilized when an option of cifsacl is specified when mounting a cifs share in conjunction with winbind facility of Samba suite.  Whether a security descriptor to be set is applied or not is determined by the CIFS/SMB server.
-.SH "OPTIONS"
-.PP
--h
-.RS 4
-Print usage message and exit.
-.RE
-\-v
-.RS 4
-Print version number and exit\&.
-.RE
-\-a
-.RS 4
-Add one or more ACEs to an ACL of a security descriptor.
-An ACE is added even if the same ACE exists in the ACL.
-.RE
-\-D
-.RS 4
-Delete one or more ACEs from an ACL of a security descriptor.
-Entire ACE has to match in an existing ACL for the listed ACEs to be deleted.
-.RE
-\-M
-.RS 4
-Modify one or more ACEs from an ACL of a security descriptor.
-SID and type are used to match for existing ACEs to be modified with the list of ACEs specified.
-.RE
-\-S
-.RS 4
-Set an ACL of security descriptor with the list of ACEs
-Existing ACL is replaced entirely with the specified ACEs.
-.RE
-.PP
-Every ACE entry starts with "ACL:"
-One or more ACEs are specified within double quotes.
-Multiple ACEs are separated by a comma.
-.PP
-Following fields of an ACE can be modified with possible values:
-.PP
-SID: Either a name or a raw SID value.
-.PP
-type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWED (0x5), OBJECT_DENIED (0x6)
-.PP
-flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLAG (CI or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG (IO or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of these values.
-.PP
-mask: Either one of FULL, CHANGE, READ, a combination of R W X D P O, or a hex value
-.SH "EXAMPLES"
-.PP
-Add an ACE
-.br
-setcifsacl -a "ACL:CIFSTESTDOM\\user2:DENIED/0x1/D" <file_name>
-setcifsacl -a "ACL:CIFSTESTDOM\\user1:ALLOWED/OI|CI|NI/D" <file_name>
-.PP
-Delete an ACE
-.br
-setcifsacl -D "ACL:S-1-1-0:0x1/OI/0x1201ff" <file_name>
-.PP
-Modify an ACE
-.br
-setcifsacl -M "ACL:CIFSTESTDOM\\user1:ALLOWED/0x1f/CHANGE" <file_name>
-.PP
-Set an ACL
-.br
-setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
-.br
-ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
-.PP
-.SH "NOTES"
-.PP
-Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
-.SH "SEE ALSO"
-.PP
-\fBmount.cifs\fR(8),
-\fBwinbindd\fR(8),
-\fBgetcifsacl\fR(1)
-.PP
-.SH "AUTHOR"
-.PP
-Shirish Pargaonkar wrote the setcifsacl program\&.
-.PP
-The
-Linux CIFS Mailing list
-is the preferred place to ask questions regarding these programs\&.
diff --git a/setcifsacl.1.in b/setcifsacl.1.in
new file mode 100644
index 0000000..5ede36a
--- /dev/null
+++ b/setcifsacl.1.in
@@ -0,0 +1,113 @@
+'\" t
+.\"     Title: cifs.idmap
+.\"    Author: [see the "AUTHOR" section]
+.\" Generator: DocBook XSL Stylesheets v1.75.2 <http://docbook.sf.net/>
+.\"      Date: 08/19/2011
+.\"    Manual: System Administration tools
+.\"    Source: cifs-utils 4.0
+.\"  Language: English
+.\"
+.TH "SETCIFSACL" "1" "08/19/2011" "cifs-utils" "CIFS Access Control List Tools"
+.\" -----------------------------------------------------------------
+.\" * set default formatting
+.\" -----------------------------------------------------------------
+.\" disable hyphenation
+.nh
+.\" disable justification (adjust text to left margin only)
+.ad l
+.\" -----------------------------------------------------------------
+.\" * MAIN CONTENT STARTS HERE *
+.\" -----------------------------------------------------------------
+.SH "NAME"
+setcifsacl \- Userspace helper to alter an ACL in a security descriptor for Common Internet File System (CIFS)
+.SH "SYNOPSIS"
+.HP \w'\ 'u
+setcifsacl [\-v|\-a|\-D|\-M|\-S] "{one or more ACEs}" {file system object}
+.SH "DESCRIPTION"
+.PP
+This tool is part of the cifs-utils suite\&.
+.PP
+setcifsacl is a userspace helper program for the Linux CIFS client file system.  It is intended to alter an ACL of a security descriptor for a file system object. 
+Whether a security descriptor to be set is applied or not is determined by the CIFS/SMB server.
+.PP
+This program uses a plugin to handle the mapping of user and group names to SIDs. \fB@pluginpath@\fR should be a symlink that points to the correct plugin to use.
+.SH "OPTIONS"
+.PP
+-h
+.RS 4
+Print usage message and exit.
+.RE
+\-v
+.RS 4
+Print version number and exit\&.
+.RE
+\-a
+.RS 4
+Add one or more ACEs to an ACL of a security descriptor.
+An ACE is added even if the same ACE exists in the ACL.
+.RE
+\-D
+.RS 4
+Delete one or more ACEs from an ACL of a security descriptor.
+Entire ACE has to match in an existing ACL for the listed ACEs to be deleted.
+.RE
+\-M
+.RS 4
+Modify one or more ACEs from an ACL of a security descriptor.
+SID and type are used to match for existing ACEs to be modified with the list of ACEs specified.
+.RE
+\-S
+.RS 4
+Set an ACL of security descriptor with the list of ACEs
+Existing ACL is replaced entirely with the specified ACEs.
+.RE
+.PP
+Every ACE entry starts with "ACL:"
+One or more ACEs are specified within double quotes.
+Multiple ACEs are separated by a comma.
+.PP
+Following fields of an ACE can be modified with possible values:
+.PP
+SID: Either a name or a raw SID value.
+.PP
+type: ALLOWED (0x0), DENIED (0x1), OBJECT_ALLOWED (0x5), OBJECT_DENIED (0x6)
+.PP
+flags: OBJECT_INHERIT_FLAG (OI or 0x1), CONTAINER_INHERIT_FLAG (CI or 0x2), NO_PROPAGATE_INHERIT_FLAG (NI or 0x4), INHERIT_ONLY_FLAG (IO or 0x8), INHERITED_ACE_FLAG (IA or 0x10) or a combination/OR of these values.
+.PP
+mask: Either one of FULL, CHANGE, READ, a combination of R W X D P O, or a hex value
+.SH "EXAMPLES"
+.PP
+Add an ACE
+.br
+setcifsacl -a "ACL:CIFSTESTDOM\\user2:DENIED/0x1/D" <file_name>
+setcifsacl -a "ACL:CIFSTESTDOM\\user1:ALLOWED/OI|CI|NI/D" <file_name>
+.PP
+Delete an ACE
+.br
+setcifsacl -D "ACL:S-1-1-0:0x1/OI/0x1201ff" <file_name>
+.PP
+Modify an ACE
+.br
+setcifsacl -M "ACL:CIFSTESTDOM\\user1:ALLOWED/0x1f/CHANGE" <file_name>
+.PP
+Set an ACL
+.br
+setcifsacl -S "ACL:CIFSTESTDOM\\Administrator:0x0/0x0/FULL,
+.br
+ACL:CIFSTESTDOM\\user2:0x0/0x0/FULL," <file_name>
+.PP
+.SH "NOTES"
+.PP
+Kernel support for getcifsacl/setcifsacl utilities was initially introduced in the 2.6.37 kernel.
+.SH "SEE ALSO"
+.PP
+\fBmount.cifs\fR(8),
+\fBgetcifsacl\fR(1)
+.PP
+.SH "AUTHOR"
+.PP
+Shirish Pargaonkar wrote the setcifsacl program\&.
+.PP
+The
+Linux CIFS Mailing list
+is the preferred place to ask questions regarding these programs\&.
-- 
1.7.11.7
