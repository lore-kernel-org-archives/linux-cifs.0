From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Convert MessageID in smb2_hdr to LE
Date: Mon, 24 Nov 2014 16:01:20 +0000
Message-ID: <1416844880.11228.6.camel@sachin-laptop>
References: <1415972511-3150-1-git-send-email-sprabhu@redhat.com>
	 <CADT32eLRVyut-c3zAYf=r6CKs=Kz+dH8NXYF32QiuAZS_qcWmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLRVyut-c3zAYf=r6CKs=Kz+dH8NXYF32QiuAZS_qcWmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2014-11-15 at 05:41 -0600, Shirish Pargaonkar wrote:
> Can get_next_mid() as well as get_next_mid64() call
> server->ops->get_next_mid(server) directly
> i.e. cpu_to_le16(server->ops->get_next_mid(server) and
>      cpu_to_le64(server->ops->get_next_mid(server) respectively
> instead of them calling additional new function__get_next_mid64()?

Hello Sirish,

Sorry for the delay, I've made the changes proposed by you. I've also
changed the type for MessageId from __u64 to __le64.

Sachin Prabhu

> 
> On Fri, Nov 14, 2014 at 7:41 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > We have encountered failures when When testing smb2 mounts on ppc64
> > machines when using both Samba as well as Windows 2012.
> >
> > On poking around, the problem was determined to be caused by the
> > high endian MessageID passed in the header for smb2. On checking the
> > corresponding MID for smb1 is converted to LE before being sent on the
> > wire.
> >
> > We have tested this using the RHEL 7 kernel where the patch fixes the
> > issue.
> >
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsglob.h | 10 ++++++++--
> >  fs/cifs/smb2pdu.h  |  2 +-
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 02a33e5..279fee8 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -662,15 +662,21 @@ set_credits(struct TCP_Server_Info *server, const int val)
> >  }
> >
> >  static inline __u64
> > -get_next_mid64(struct TCP_Server_Info *server)
> > +_get_next_mid64(struct TCP_Server_Info *server)
> >  {
> >         return server->ops->get_next_mid(server);
> >  }
> >
> > +static inline __le64
> > +get_next_mid64(struct TCP_Server_Info *server)
> > +{
> > +       return cpu_to_le64(_get_next_mid64(server));
> > +}
> > +
> >  static inline __le16
> >  get_next_mid(struct TCP_Server_Info *server)
> >  {
> > -       __u16 mid = get_next_mid64(server);
> > +       __u16 mid = _get_next_mid64(server);
> >         /*
> >          * The value in the SMB header should be little endian for easy
> >          * on-the-wire decoding.
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index e3188ab..ac27eac 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -110,7 +110,7 @@ struct smb2_hdr {
> >         __le16 CreditRequest;  /* CreditResponse */
> >         __le32 Flags;
> >         __le32 NextCommand;
> > -       __u64  MessageId;       /* opaque - so can stay little endian */
> > +       __u64  MessageId;
> >         __le32 ProcessId;
> >         __u32  TreeId;          /* opaque - so do not make little endian */
> >         __u64  SessionId;       /* opaque - so do not make little endian */
> > --
> > 1.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
