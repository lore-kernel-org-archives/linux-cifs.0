From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: smb2pdu.c merged
Date: Tue, 8 Mar 2011 00:10:38 -0600
Message-ID: <AANLkTi=JhKhrS57TsWo9=wOSejDy4Hi6+i=PsjCShOP7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Although the move of smb2 support from the smb2.ko (distinct module)
to a part of cifs.ko is turning out better than expected, I am trying
to do the conversions carefully (to the older cifs specific function
names where there is possibility of reusing the cifs version of the
code, and adding minor changes to the cifs code to accommodate missing
structure elements for example).   The merge of the smb2pdu.c worker
functions and protocol definitions (not very exciting as they match
what is in the spec) and some related dependencies (worker functions,
and some temporary stub transport functions) was too large to inline
in an email.  It is in commit:

http://git.kernel.org/?p=linux/kernel/git/sfrench/cifs-2.6.git;a=commitdiff;h=ba1d3280429890c37bc5668136d26ba7afb26cd8

Obviously some of these functions could change slightly as new
versions of (more "cifs-integrated" transport worker functions get
merged in, and we try to incorporate some of Jeff's ideas for fixups
to cifs_demultiplex_thread (for example) but it is important to get
the code back to where we can do a stable mount and file system
operations.

So far, the amount of common code between smb2 and cifs looks like it
could be somewhat higher than expected with this approach.

-- 
Thanks,

Steve
