From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mids and cifs sendrcv2
Date: Fri, 8 Apr 2011 11:39:31 -0500
Message-ID: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Update on cifs vs. smb2 mids, and the smb2 sendrcv2.   Jeff had
suggested more closely matching the cifs and smb2 mids, in particular
extending the 16 bit cifs mid (multiplex identifier for inflight
network requests) to the 64 bit size needed for smb2 (and thus masking
the mid when used for cifs) and having cifs ignore the various smb2
unique fields in the mid (which makes the mid larger for cifs).
Since the smb2 code in cifs-2.6.git (put in February and early March)
has now been rereviewed, the next step in the smb2 merge is posting
and reviewing the transport routine for smb2 (smb2_sendrcv2 or reusing
cifs_sendrcv2) - the latter may make more sense if we go to a common
mid for cifs and smb2.   At the fs summit, Jeff and Jeremy and I
talked about this, but Pavel and others may have opinions on this
topic.   As soon as the cifs merge activity settles down for 2.6.39, I
plan to post sendrcv2 alternatives and then begin work with Pavel on
the superblock, file and inode routines and seeing whether for smb2
they should be smb2 unique (as we originally expected since smb2 is
handle based, and simpler) and look more like they did in the smb2.ko
work that Pavel did last summer or should be more common with the cifs
routines.

-- 
Thanks,

Steve
