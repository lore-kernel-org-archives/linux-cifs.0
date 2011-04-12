From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: shrinking set of cifs fixes to merge for 2.6.39 to small set
Date: Mon, 11 Apr 2011 20:33:42 -0500
Message-ID: <BANLkTi=72h+nv9BfB+1e69tW4Hb_u5U_TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Since it is already past the merge window (was waiting to discuss some
fixes with others at the fs summit last week before merge),  I shrunk
the list of cifs patches waiting for merge (in cifs-2.6.git) to a much
smaller set of more critical ones. See below. (I moved the others
temporarily to a for-2.6.40 branch in cifs-2.6.git).  We (Jeff,
Shirish, I etc.) need to build/test more with this set before sending
though.

Jeff Layton (8):
      cifs: check for private_data before trying to put it
      cifs: replace /proc/fs/cifs/Experimental with a module parm
      cifs: always do is_path_accessible check in cifs_mount
      cifs: fix broken BCC check in is_valid_oplock_break
      cifs: set ra_pages in backing_dev_info
      cifs: clean up length checks in check2ndT2
      cifs: clean up various nits in unicode routines (try #2)
      cifs: wrap received signature check in srv_mutex

Steve French (6):
      Allow user names longer than 32 bytes
      Max share size is too small
      Elminate sparse __CHECK_ENDIAN__ warnings on port conversion
      various endian fixes to cifs
      [CIFS] cifs: clarify the meaning of tcpStatus == CifsGood
      [CIFS] Warn on requesting default security (ntlm) on mount





-- 
Thanks,

Steve
