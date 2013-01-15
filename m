From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC] cifs: revalidate directories instiantiated via FIND_*
 in order to handle DFS referrals
Date: Tue, 15 Jan 2013 13:34:07 -0600
Message-ID: <CAH2r5muYbaZewY3WjLXWF54R7DSPDswU9x1U87xj=2qFXnt5dQ@mail.gmail.com>
References: <1358276491-4835-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358276491-4835-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 15, 2013 at 1:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> We've had a long-standing problem with DFS referral points. CIFS servers
> generally try to make them look like directories in FIND_FIRST/NEXT
> responses. When you go to try to do a FIND_FIRST on them though, the
> server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
> manifests as spurious EREMOTE errors back to userland.

Why would we ever return STATUS_PATH_NOT_COVERED (converted to
EREMOTE)?  If we do a find first on a directory and get status path
not covered - why don't we simply chase the DFS referral then rather
than greatly slow down findfirst?

-- 
Thanks,

Steve
