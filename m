From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Connection problems using kerberos against EMC Celerra servers
Date: Tue, 28 Dec 2010 09:41:30 +0100
Message-ID: <1293525693-11562-1-git-send-email-metze@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

EMC Celerra server reject session setups with
RPC_NT_INVALID_BINDING (0xc0020003) if the authenticator checksum
uses CKSUMTYPE_HMAC_MD5(-138).

The correct fix for this is to use the GSSAPI checksum,
see http://tools.ietf.org/html/rfc4121.

See also https://bugzilla.samba.org/show_bug.cgi?id=7890

metze
