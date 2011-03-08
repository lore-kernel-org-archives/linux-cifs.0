From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: max sharename
Date: Mon, 7 Mar 2011 19:05:15 -0600
Message-ID: <AANLkTi=HB0rONJdLawea1F6kAZ=seqNUpu_uGsk3bm0C@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In correcting the SMB2 tree connect code, I noticed that cifs
tcon->treeName is artificially limited to 84 bytes (with share name
part limited to 64), but I verified that share name can be 80 bytes
now (at least to Windows).   I will update MAX_SHARE_SIZE to fix this.

-- 
Thanks,

Steve
