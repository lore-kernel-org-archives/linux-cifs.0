From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v3 6/7] NFSv4: Add O_DENY* open flags support
Date: Thu, 4 Apr 2013 14:30:12 +0400
Message-ID: <CAKywueRSTipeO8V-oNrM=jM8WUo7Dd0ahj_Xcw8f8ViE3NGEOQ@mail.gmail.com>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<1362065133-9490-7-git-send-email-piastry@etersoft.ru>
	<20130311145434.707f5ed1@corrin.poochiereds.net>
	<20130312083517.770a17f6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130312083517.770a17f6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/3/12 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Mon, 11 Mar 2013 14:54:34 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Thu, 28 Feb 2013 19:25:32 +0400
>> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>>
>> > by passing these flags to NFSv4 open request.
>> >
>> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> > ---
>> >  fs/nfs/nfs4xdr.c | 24 ++++++++++++++++++++----
>> >  1 file changed, 20 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
>> > index 26b1439..58ddc74 100644
>> > --- a/fs/nfs/nfs4xdr.c
>> > +++ b/fs/nfs/nfs4xdr.c
>> > @@ -1325,7 +1325,8 @@ static void encode_lookup(struct xdr_stream *xdr, const struct qstr *name, struc
>> >     encode_string(xdr, name->len, name->name);
>> >  }
>> >
>> > -static void encode_share_access(struct xdr_stream *xdr, fmode_t fmode)
>> > +static void encode_share_access(struct xdr_stream *xdr, fmode_t fmode,
>> > +                           int open_flags)
>> >  {
>> >     __be32 *p;
>> >
>> > @@ -1343,7 +1344,22 @@ static void encode_share_access(struct xdr_stream *xdr, fmode_t fmode)
>> >     default:
>> >             *p++ = cpu_to_be32(0);
>> >     }
>> > -   *p = cpu_to_be32(0);            /* for linux, share_deny = 0 always */
>> > +   if (open_flags & O_DENYMAND) {
>>
>>
>> As Bruce mentioned, I think a mount option to enable this on a per-fs
>> basis would be a better approach than this new O_DENYMAND flag.
>>
>>
>> > +           switch (open_flags & (O_DENYREAD|O_DENYWRITE)) {
>> > +           case O_DENYREAD:
>> > +                   *p = cpu_to_be32(NFS4_SHARE_DENY_READ);
>> > +                   break;
>> > +           case O_DENYWRITE:
>> > +                   *p = cpu_to_be32(NFS4_SHARE_DENY_WRITE);
>> > +                   break;
>> > +           case O_DENYREAD|O_DENYWRITE:
>> > +                   *p = cpu_to_be32(NFS4_SHARE_DENY_BOTH);
>> > +                   break;
>> > +           default:
>> > +                   *p = cpu_to_be32(0);
>> > +           }
>> > +   } else
>> > +           *p = cpu_to_be32(0);
>> >  }
>> >
>> >  static inline void encode_openhdr(struct xdr_stream *xdr, const struct nfs_openargs *arg)
>> > @@ -1354,7 +1370,7 @@ static inline void encode_openhdr(struct xdr_stream *xdr, const struct nfs_opena
>> >   * owner 4 = 32
>> >   */
>> >     encode_nfs4_seqid(xdr, arg->seqid);
>> > -   encode_share_access(xdr, arg->fmode);
>> > +   encode_share_access(xdr, arg->fmode, arg->open_flags);
>> >     p = reserve_space(xdr, 36);
>> >     p = xdr_encode_hyper(p, arg->clientid);
>> >     *p++ = cpu_to_be32(24);
>> > @@ -1491,7 +1507,7 @@ static void encode_open_downgrade(struct xdr_stream *xdr, const struct nfs_close
>> >     encode_op_hdr(xdr, OP_OPEN_DOWNGRADE, decode_open_downgrade_maxsz, hdr);
>> >     encode_nfs4_stateid(xdr, arg->stateid);
>> >     encode_nfs4_seqid(xdr, arg->seqid);
>> > -   encode_share_access(xdr, arg->fmode);
>> > +   encode_share_access(xdr, arg->fmode, 0);
>> >  }
>> >
>> >  static void
>>
>>
>> Other than that, this seems reasonable.
>>
>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Oh duh...
>
> Please ignore my comment on patch #7 to add a patch for the NFS client.
> This one does that. That said, there may be a potential problem here
> that you need to consider.
>
> In the case of a local filesystem you'll want to set deny locks using
> deny_lock_file(). For a network filesystem like CIFS or NFS though,
> the server will handle that atomically during the open. You need to
> ensure that you don't go trying to set LOCK_MAND locks on the file once
> that's done.
>
> Perhaps you can use a fstype flag to indicate that the filesystem
> handles this during the open and doesn't need to try and set a flock
> lock?

Also, we can simply mask off O_DENY* flags in open (and atomic_open)
codepath of filesystems that support these flags:

...
do open request to the storage
...
file->f_flags &= ~(O_DENYREAD | O_DENYWRITE | O_DENYDELETE);
...
return to VFS
...

Thoughts?

--
Best regards,
Pavel Shilovsky.
