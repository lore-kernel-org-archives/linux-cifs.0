From: Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] Cifs and Ceph: Uncache single no-data page in readpage()
Date: Mon, 11 Nov 2013 11:19:49 -0500
Message-ID: <CANP1eJE9zGN1ort4DdEdvvG4MVneRnjh+MnrdHkyy==ruEBCnw@mail.gmail.com>
References: <cover.1384183054.git.liwang@ubuntukylin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>,
	"linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1384183054.git.liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Li,

I recommend you CC David Howells who maintains FSCache directly on your emails.

Thanks,
- Milosz

On Mon, Nov 11, 2013 at 10:27 AM, Li Wang <liwang-qfb7ZC4agRC9jIzG8Sm66w@public.gmane.org> wrote:
> Currently, the page allocated into fscache in readpage()
> for Cifs and Ceph does not be uncached if no data read due
> to io error. This patch fixes this. fscache_readpages_cancel()
> is for this kind of job but taking list read * as input, so
> a new routine take page * as input is introduced.
>
> Li Wang (7):
>   Fscache: Introduce new API fscache_readpage_cancel()
>   Fscache: Implement uncaching single no-data page
>   Ceph: Introduce routine for uncaching single no-data page
>   Ceph: Uncaching no-data page in readpage()
>   Cifs: Introduce routine for uncaching single no-data page
>   Cifs: Implement uncaching single no-data page
>   Cifs: Uncaching no-data page in readpage()
>
>  fs/ceph/addr.c          |    1 +
>  fs/ceph/cache.h         |   13 +++++++++++++
>  fs/cifs/file.c          |    4 +++-
>  fs/cifs/fscache.c       |    7 +++++++
>  fs/cifs/fscache.h       |   13 +++++++++++++
>  fs/fscache/page.c       |    8 ++++++++
>  include/linux/fscache.h |   11 +++++++++++
>  7 files changed, 56 insertions(+), 1 deletion(-)
>
> --
> 1.7.9.5
>



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org
