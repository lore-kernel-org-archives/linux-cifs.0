From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/2] cifs: Support for an upcall to map a SID to an uid and a gid (try #5)
Date: Fri, 11 Feb 2011 12:48:45 -0600
Message-ID: <1297450125-31560-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use a cifs upcall to map a SID to either an uid or a gid using winbind.

There is a corrosponding patch for the cifs.upcall binary in cifs-utils rpm
that has been posted.

A new type of key, cifs_idmap_key_type, is used.

For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
it would be used to obtain an SID (string) for an id.

This patch does not address client side permission checking and
id assignments if and when there is an error in SID mapping.
Default id assigned is that of 0 (root/superuser) for now.

An entry such as this

create  cifs.cifs_idmap   *       *               /usr/sbin/cifs.upcall %k

is needed in the file /etc/request-key.conf.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
