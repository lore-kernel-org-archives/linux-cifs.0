From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/5] cifs-utils: cifsacl utilities: Implement getcifsacl and setcifsacl
Date: Fri, 19 Aug 2011 22:27:12 -0500
Message-ID: <1313810832-2245-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Implement utilities getcifsacl and setcifsacl


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Set of patches to build utilities getcifsacl and setcifsacl
along with their manpages.

getcifsacl fetches a security descriptor of a file off of a
share mounted using option cifsacl using API getxattr.
It then parses the security descriptor printing control
porttion of the security descriptor and then DACL if there
is one by printing each ACE with it fields, SID, type, flags, and mask.

setcifsacl builds two lists of ACEs, one specified on the command line
and other fetched from the file the way getcifacl does.
It then constructs a security descriptor consisting of ACL
and uses API setxattr to send the security descriptor as a blob to
the server.  setcifsacl also works with files off of shares
mounted with option cifsacl.

manpages are provided for both the utilities with some examples
in setcifsacl manpage.  The usage of getcifsacl is simple and
very much self explanatory.
 
With these utilities, there is a way to interprete and construct a
blob describing security descritpor of a file system object.

These utilities are modeled after smbcacls command in the
Samba suite.
