From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: check for NULL last_entry before calling cifs_save_resume_key
Date: Tue, 15 Nov 2011 10:13:28 -0600
Message-ID: <CAH2r5ms27jRtPEcZdhA-OUO+TcgTvu+s9BQRna4KQxMxuX2T-w@mail.gmail.com>
References: <1321361966-24961-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321361966-24961-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This looks trivially correct to me, the check also could be in
cifs_save_resume_key
but I don't think it matters.   I will wait a day to allow anyone else =
to
comment or ack.

On Tue, Nov 15, 2011 at 6:59 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Prior to commit eaf35b1, cifs_save_resume_key had some NULL pointer
> checks at the top. It turns out that at least one of those NULL
> pointer checks is needed after all.
>
> When the LastNameOffset in a FIND reply appears to be beyond the end =
of
> the buffer, CIFSFindFirst and CIFSFindNext will set srch_inf.last_ent=
ry
> to NULL. Since eaf35b1, the code will now oops in this situation.
>
> Fix this by having the callers check for a NULL last entry pointer
> before calling cifs_save_resume_key. No change is needed for the
> call site in cifs_readdir as it's not reachable with a NULL
> current_entry pointer.
>
> This should fix:
>
> =A0 =A0https://bugzilla.redhat.com/show_bug.cgi?id=3D750247
>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Reported-by: Adam G. Metzler <adamgmetzler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/readdir.c | =A0 10 ++++++++--
> =A01 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 5de03ec..a090bbe 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -554,7 +554,10 @@ static int find_cifs_entry(const int xid, struct=
 cifs_tcon *pTcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_save_resume_key(cifsFile->srch_inf=
=2Elast_entry, cifsFile);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FindFirst/Next set last_entry to NUL=
L on malformed reply */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifsFile->srch_inf.last_entry)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_save_resume_key(ci=
fsFile->srch_inf.last_entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 cifsFile);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0while ((index_to_find >=3D cifsFile->srch_inf.index_of=
_last_entry) &&
> @@ -562,7 +565,10 @@ static int find_cifs_entry(const int xid, struct=
 cifs_tcon *pTcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "calling findnext2");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSFindNext(xid, pTcon, cifsFi=
le->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&c=
ifsFile->srch_inf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_save_resume_key(cifsFile->srch_inf=
=2Elast_entry, cifsFile);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FindFirst/Next set last_entry to NUL=
L on malformed reply */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifsFile->srch_inf.last_entry)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_save_resume_key(ci=
fsFile->srch_inf.last_entry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 cifsFile);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOENT;
> =A0 =A0 =A0 =A0}
> --
> 1.7.6.4
>
>



--=20
Thanks,

Steve
