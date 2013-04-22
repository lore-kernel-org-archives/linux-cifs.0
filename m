From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: revalidate directories instiantiated via FIND_*
 in order to handle DFS referrals
Date: Mon, 22 Apr 2013 14:38:40 -0400
Message-ID: <20130422143840.485e5aaf@tlielax.poochiereds.net>
References: <1366627391-14753-1-git-send-email-sprabhu@redhat.com>
	<20130422072006.7a51d386@tlielax.poochiereds.net>
	<CAH2r5mvQkKjth5SpUfM-MeisBYB3aqcYLxHaTxkAOzyDxGYMcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvQkKjth5SpUfM-MeisBYB3aqcYLxHaTxkAOzyDxGYMcA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Apr 2013 13:28:49 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Apr 22, 2013 at 6:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Mon, 22 Apr 2013 11:43:11 +0100
> > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> >> From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >> We've had a long-standing problem with DFS referral points. CIFS servers
> >> generally try to make them look like directories in FIND_FIRST/NEXT
> >> responses. When you go to try to do a FIND_FIRST on them though, the
> >> server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
> >> manifests as spurious EREMOTE errors back to userland.
> >>
> >> This patch attempts to fix this by marking directories that are
> >> discovered via FIND_FIRST/NEXT for revaldiation. When the lookup code
> >> runs across them again, we'll reissue a QPathInfo against them and that
> >> will make it chase the referral properly.
> >>
> >> There is some performance penalty involved here and no I haven't
> >> measured it -- it'll be highly dependent upon the workload and contents
> >> of the mounted share. To try and mitigate that though, the code only
> >> marks the inode for revalidation when it's possible to run across a DFS
> >> referral. i.e.: when the kernel has DFS support built in and the share
> >> is "in DFS".
> >>
> >> This also fixes a security issue where a user can cause an Oops due to
> >> uninitialised inode pointers. Reproducer available at
> >> https://patchwork.kernel.org/patch/1980301/
> >
> > While it might cause performance to regress in some cases, I see no
> > real alternative to this patch. It's necessary to do some operation
> > specifically against the path before allowing someone to chdir into it.
> > Doing anything else means that you'll miss your chance to trigger an
> > automount if it does turn out to be a DFS referral.
> >
> > That said, there are other possible races too, so I think we also need
> > a patch to fix the client not to call cifs_set_ops unless the inode is
> > still in I_NEW state.
> 
> That latter point mentioned  by Jeff, to address the oops itself, is fairly
> urgent, as the readdir change you describe doesn't fix all of the scenarios.
> For your suggested patch (don't cache stat or readdir information for
> directories) - I am uncomfortable with the performance impact so want
> to find out two key things before we turn off caching as you suggest
> for this case:
> 
> 1) Is there anyway to tell the difference (using a higher Find info level
> for example, especially in SMB2/SMB3 but also in cifs if possible)
> between a directory and a DFS junction in directory search results?
> 
> 2) Is there anyway to narrow the negative performance impact
> (ie cache some of these but not others, for example if we know
> that a directory with certain other common attributes set can never
> be a DFS referral so can be safely cached).   I am uncomfortable,
> especially given Samba's performance on recursive directory searches
> with turning off caching of these unless there is no other way to tell
> the difference between directories and DFS junctions, at least for
> the POSIX case (Unix Extensions, ie Samba server),
> if not also for the Windows server case
> 


I looked a while back and didn't see one, but I'm happy to be proven
wrong on this point if you do find a way.

Given that this is a correctness issue, would it be reasonable to go
ahead and merge this for 3.10 since we don't have another fix queued up
for this? If it turns out that you find a better way you can always
back this patch out once that's implemented.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
