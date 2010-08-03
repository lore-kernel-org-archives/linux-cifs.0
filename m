From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [CIFS] Support for Minshall+French symlinks
Date: Tue,  3 Aug 2010 17:05:52 +0200
Message-ID: <1280847960-16371-1-git-send-email-metze@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

The following patchset adds support Minshall+French symlinks for Linux.
See http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks

I've added a new mount option 'mfsymlinks', which is off by default.

If the option is pass to a mount, Minshall+French symlinks will be used
to support symlinks for the local client.

This is compatible with the Darwin implementation.

Can you review this patches? It would be wonderful if they would endup
in Linux 2.6.36.

metze
