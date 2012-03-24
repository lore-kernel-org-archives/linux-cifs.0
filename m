From: =?iso-8859-1?q?G=FCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: During negprot request, shouldn't cifs _always_ set the "extended security negotiation" bit in flags2 ?
Date: Sat, 24 Mar 2012 05:31:09 +0100
Message-ID: <201203240531.10450.linux@kukkukk.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

some background:

cifs tried to connect to a XP box, which was joined to a domain.
smbclient (and Mac) were working - cifs not.

On that XP box GPOs (or others) were set in that way, that _only_
NTLMSSP connections were allowed at all.

During the "negotiate protocol" request, cifs does _not_ set the
"extended security negotiation" bit in flags2.
    in cifs terms: #define SMBFLG2_EXT_SEC cpu_to_le16(0x800)
Cifs supports that - but does not offer that capability to the server.

So the XP server did response to _not_ support extended security in
the capabilities field...
Cifs tried default ntlm - and failed to connect.
Any mount options regarding "sec=3D....." don't help here!

So shouldn't cifs _always_ set the "extended security negotiation" bit =
in flags2
during negprot (to get proper server caps)?

Atm one can workaround with:

echo 0x80080 > /proc/fs/cifs/SecurityFlags   or
echo 0x80    > /proc/fs/cifs/SecurityFlags

to force NTLMSSP.

Cheers, G=FCnter
