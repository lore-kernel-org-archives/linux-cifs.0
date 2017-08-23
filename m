From: Steve French <smfrench@gmail.com>
Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA read for
 SMB write
Date: Wed, 23 Aug 2017 14:39:46 -0500
Message-ID: <CAH2r5mub3KMQaEKV0V10ZtxTGweCRn9rmDa64o5hi0b-+ZuMBg@mail.gmail.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
 <20170823135200.GP1724@mtr-leonro.local> <MWHPR21MB0190DBBDE3317D973FEF0E43CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
 <20170823190214.GY1724@mtr-leonro.local> <MWHPR21MB0190DDCDB0B5F8FED3265A60CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Leon Romanovsky <leon@kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>
To: Long Li <longli@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <MWHPR21MB0190DDCDB0B5F8FED3265A60CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Note that Camel Case in cifs.ko source is largely used for protocol
definitions to match the official protocol documentation.  So we
expect Camel Case only where it is meant to express the **exact** name
of a field in the official specification of the wire protocol but
there may be some legacy code (unrelated to protocol wire format) that
still uses camel case - and that could be cleaned up with other
patches outside this series but is lower priority.

On Wed, Aug 23, 2017 at 2:10 PM, Long Li via samba-technical
<samba-technical@lists.samba.org> wrote:
>
>
>> -----Original Message-----
>> From: Leon Romanovsky [mailto:leon@kernel.org]
>> Sent: Wednesday, August 23, 2017 12:02 PM
>> To: Long Li <longli@microsoft.com>
>> Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
>> technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-
>> rdma@vger.kernel.org; Christoph Hellwig <hch@infradead.org>; Tom Talpey
>> <ttalpey@microsoft.com>; Matthew Wilcox <mawilcox@microsoft.com>
>> Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA
>> read for SMB write
>>
>> On Wed, Aug 23, 2017 at 06:09:11PM +0000, Long Li wrote:
>> >
>> >
>> > > -----Original Message-----
>> > > From: Leon Romanovsky [mailto:leon@kernel.org]
>> > > Sent: Wednesday, August 23, 2017 6:52 AM
>> > > To: Long Li <longli@microsoft.com>
>> > > Cc: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org;
>> > > samba- technical@lists.samba.org; linux-kernel@vger.kernel.org;
>> > > linux- rdma@vger.kernel.org; Christoph Hellwig <hch@infradead.org>;
>> > > Tom Talpey <ttalpey@microsoft.com>; Matthew Wilcox
>> > > <mawilcox@microsoft.com>; Long Li <longli@microsoft.com>
>> > > Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA
>> > > read for SMB write
>> > >
>> > > On Sun, Aug 20, 2017 at 12:04:37PM -0700, Long Li wrote:
>> > > > From: Long Li <longli@microsoft.com>
>> > > >
>> > > > When sending I/O, if size is larger than rdma_readwrite_threshold
>> > > > we
>> > > prepare to send SMB WRITE packet for a RDMA read via memory
>> registration.
>> > > The actual I/O is done out-of-the-band, so modify the relevant
>> > > fields in the packet accordingly.
>> > > >
>> > > > Signed-off-by: Long Li <longli@microsoft.com>
>> > > > ---
>> > > >  fs/cifs/smb2pdu.c | 45
>> > > ++++++++++++++++++++++++++++++++++++++++++++-
>> > > >  1 file changed, 44 insertions(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index
>> > > > 5cc5f6c..5581afd 100644
>> > > > --- a/fs/cifs/smb2pdu.c
>> > > > +++ b/fs/cifs/smb2pdu.c
>> > > > @@ -48,6 +48,7 @@
>> > > >  #include "smb2glob.h"
>> > > >  #include "cifspdu.h"
>> > > >  #include "cifs_spnego.h"
>> > > > +#include "smbdirect.h"
>> > > >
>> > > >  /*
>> > > >   *  The following table defines the expected "StructureSize" of
>> > > > SMB2 requests @@ -2716,6 +2717,41 @@ smb2_async_writev(struct
>> > > cifs_writedata *wdata,
>> > > >                                 offsetof(struct smb2_write_req, Bu=
ffer) - 4);
>> > > >         req->RemainingBytes =3D 0;
>> > > >
>> > > > +       /*
>> > > > +        * If we want to do a server RDMA read, fill in and append
>> > > > +        * smbd_buffer_descriptor_v1 to the end of write request
>> > > > +        */
>> > > > +       if (server->rdma && wdata->bytes >
>> > > > +               server->smbd_conn->rdma_readwrite_threshold) {
>> > > > +
>> > > > +               struct smbd_buffer_descriptor_v1 *v1;
>> > > > +               bool need_invalidate =3D server->dialect =3D=3D SM=
B30_PROT_ID;
>> > > > +
>> > > > +               wdata->mr =3D smbd_register_mr(
>> > > > +                               server->smbd_conn, wdata->pages,
>> > > > +                               wdata->nr_pages, wdata->tailsz,
>> > > > +                               false, need_invalidate);
>> > > > +               if (!wdata->mr) {
>> > > > +                       rc =3D -ENOBUFS;
>> > > > +                       goto async_writev_out;
>> > > > +               }
>> > > > +               req->Length =3D 0;
>> > > > +               req->DataOffset =3D 0;
>> > > > +               req->RemainingBytes =3D
>> > >
>> > > Wow, we have CamelCase variables in linux kernel. It will help if
>> > > you start your patchset with small cleanup to convert those
>> > > variables from CamelCase to normal names.
>> >
>> > They are used everywhere in the upper layer code for packet
>> > definitions, written a long time ago. (most in fs/cifs/smb2pdu.h and
>> > fs/cifs/cifspdu.h)
>>
>> "everywhere" is a little bit over estimated in this case.
>> =E2=9E=9C  linux-rdma git:(master) git grep RemainingBytes
>> fs/cifs/smb2pdu.c:              req->RemainingBytes =3D
>> cpu_to_le32(remaining_bytes);
>> fs/cifs/smb2pdu.c:              req->RemainingBytes =3D 0;
>> fs/cifs/smb2pdu.c:      req->RemainingBytes =3D 0;
>> fs/cifs/smb2pdu.c:      req->RemainingBytes =3D 0;
>> fs/cifs/smb2pdu.h:      __le32 RemainingBytes;
>> fs/cifs/smb2pdu.h:      __le32 RemainingBytes;
>>
>> One simple "sed -i" will replace all them in one shot and it doesn't loo=
k like
>> undoable task.
>
> I mean cifspdu.h and smb2pdu.h. use CamelCase for all packet definitions.=
 For example another one in smb2pdu.h:
> struct smb2_negotiate_rsp {
>         struct smb2_hdr hdr;
>         __le16 StructureSize;   /* Must be 65 */
>         __le16 SecurityMode;
>         __le16 DialectRevision;
>         __le16 NegotiateContextCount;   /* Prior to SMB3.1.1 was Reserved=
 & MBZ */
>         __u8   ServerGUID[16];
>         __le32 Capabilities;
>         __le32 MaxTransactSize;
>         __le32 MaxReadSize;
>         __le32 MaxWriteSize;
>         __le64 SystemTime;      /* MBZ */
>         __le64 ServerStartTime;
>         __le16 SecurityBufferOffset;
>         __le16 SecurityBufferLength;
>         __le32 NegotiateContextOffset;  /* Pre:SMB3.1.1 was reserved/igno=
red */
>         __u8   Buffer[1];       /* variable length GSS security buffer */
> } __packed;
>
> We may want to change them all together to keep naming consistent, that's=
 a lot of changes.
>
>>
>> >
>> > I suggest we do another cleanup patch to clean things up.
>>
>> Yes, another cleanup patch is needed before your patches. You are adding
>> your code in 2017 and you are expected to follow present coding standard=
s
>> like everyone else in the kernel.
>>
>> Thanks



--=20
Thanks,

Steve
