From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: portions of smb2 patches which hit existing cifs code were smaller
 than I expected
Date: Fri, 28 Oct 2011 10:40:39 -0500
Message-ID: <CAH2r5mvZZBOEnDi8zTWRQgs4VeyQa0i+tBQzaGXEHyoBFEJ9SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

About a month ago when I was reviewing Pavel's smb2 patches again, I
noticed that he only hits ~1000 lines or so of common cifs code (much
of that is ifdeffed out when smb2 not enabled in Kconfig), the primary
exceptions to this are increases to the size of some elements in cifs
data structures (like the mid and the smb session structures) to
account for the higher smb2 limits (larger process ids for example).
Obviously the vast majority of the smb2 code is disabled when the
corresponding Kconfig parm is off, but I was particularly interested
in the pieces which hit common code, which ended up smaller than I
expected.

-- 
Thanks,

Steve
