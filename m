From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: queued patches for 3.10
Date: Fri, 24 May 2013 13:21:06 -0500
Message-ID: <CAH2r5msJ1zza9KzOHeFYShjVm98S+wWF_e-bufkiUct+QhF77Q@mail.gmail.com>
References: <20130524074937.0f225d12@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130524074937.0f225d12-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I sent a merge request for the setops fix, the other five in your
for-3.10 are queued in the for-3.10 branch (and for-3.11 branch there
are five more in for-3.11 from your longer series that I have already
reviewed and put in - note that this for-3.11 branch is soon to be
called "for-next" so linux-next will be building it)

In the series of patches for-3.10 I did fix up two formatting errors
that checkpatch noticed:

ERROR: space required before the open parenthesis '('
#34: FILE: fs/cifs/connect.c:1261:
+	switch(cifs_parse_devname(devname, vol)) {

total: 1 errors, 0 warnings, 34 lines checked

/home/stevef/Downloads/patch3 has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
total: 0 errors, 0 warnings, 9 lines checked

/home/stevef/Downloads/patch4 has no obvious style problems and is
ready for submission.
ERROR: space required before the open parenthesis '('
#98: FILE: fs/cifs/cifs_dfs_ref.c:81:
+	while(*pos == '\\') {

total: 1 errors, 0 warnings, 197 lines checked

I have reviewed 3 of the 5 of your most recent patches in for-3.10,
but would appreciate more review especially on the two larger ones
("fix error handling ..."  and "fix composing ...") in that series.

On Fri, May 24, 2013 at 6:49 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I just noticed that this patch is still not in mainline:
>
>     cifs: only set ops for inodes in I_NEW state
>
> ...is there a problem with it? It really needs to go in soon if not.
>
> Also, I posted a few other patches on Tuesday that need to go into 3.10
> as well:
>
>     cifs: fix error handling when calling cifs_parse_devname
>     cifs: allow sec=none mounts to work against servers that don't support extended security
>     cifs: stop printing the unc= option in /proc/mounts
>
> ...this one also needs to go to stable:
>
>     cifs: fix potential buffer overrun when composing a new options string
>
> ...and the last version of this patch that I posted should have had a
> [PATCH v3] in the subject, but I forgot to add that:
>
>     cifs: fix composing of mount options for DFS referrals
>
> ...that patch is based on top of the previous patch that's slated for
> stable. All of these patches are in my cifs-3.10 branch if you want to
> just cherry-pick them from there:
>
>     http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/cifs-3.10
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



-- 
Thanks,

Steve
