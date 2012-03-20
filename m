From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 09/11] CIFS: Separate protocol-specific code from
 cifs_readv_receive code
Date: Tue, 20 Mar 2012 06:24:14 -0400
Message-ID: <20120320062414.554a033c@tlielax.poochiereds.net>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-10-git-send-email-piastry@etersoft.ru>
	<20120319161728.1f8cec40@redhat.com>
	<CAKywueSvsb+BP7ktb0QEgL3WmrO8j42bicvd-WjWNro6qGRc7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSvsb+BP7ktb0QEgL3WmrO8j42bicvd-WjWNro6qGRc7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 20 Mar 2012 11:33:42 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 20 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 0:17 =D0=BF=D0=BE=
=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff Layto=
n <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > On Fri, 16 Mar 2012 18:09:32 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 12 ++++++++++
> >> =C2=A0fs/cifs/cifsproto.h | =C2=A0 =C2=A02 +-
> >> =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0 58 +++++++++++++++++++++++=
++++++++++-----------------
> >> =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0 12 ----------
> >> =C2=A0fs/cifs/netmisc.c =C2=A0 | =C2=A0 =C2=A03 +-
> >> =C2=A05 files changed, 53 insertions(+), 34 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 34a897e..a403398 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -341,6 +341,18 @@ has_credits(struct TCP_Server_Info *server, i=
nt *credits)
> >> =C2=A0 =C2=A0 =C2=A0 return num > 0;
> >> =C2=A0}
> >>
> >> +static inline size_t
> >> +header_size(void)
> >> +{
> >> + =C2=A0 =C2=A0 return sizeof(struct smb_hdr);
> >> +}
> >> +
> >> +static inline size_t
> >> +max_header_size(void)
> >> +{
> >> + =C2=A0 =C2=A0 return MAX_CIFS_HDR_SIZE;
> >> +}
> >> +
> >> =C2=A0/*
> >> =C2=A0 * Macros to allow the TCP_Server_Info->net field and relate=
d code to drop out
> >> =C2=A0 * when CONFIG_NET_NS isn't set.
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index 15c9b59..db38a40 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -106,7 +106,7 @@ extern int cifs_convert_address(struct sockadd=
r *dst, const char *src, int len);
> >> =C2=A0extern int cifs_set_port(struct sockaddr *addr, const unsign=
ed short int port);
> >> =C2=A0extern int cifs_fill_sockaddr(struct sockaddr *dst, const ch=
ar *src, int len,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const unsigned short int port);
> >> -extern int map_smb_to_linux_error(struct smb_hdr *smb, bool logEr=
r);
> >> +extern int map_smb_to_linux_error(char *buf, bool logErr);
> >> =C2=A0extern void header_assemble(struct smb_hdr *, char /* comman=
d */ ,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 const struct cifs_tcon *, int /* length of
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 fixed section (word count) in two byte units *=
/);
> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >> index d3b8089..765f804 100644
> >> --- a/fs/cifs/cifssmb.c
> >> +++ b/fs/cifs/cifssmb.c
> >> @@ -1415,8 +1415,7 @@ cifs_readdata_free(struct cifs_readdata *rda=
ta)
> >> =C2=A0static int
> >> =C2=A0cifs_readv_discard(struct TCP_Server_Info *server, struct mi=
d_q_entry *mid)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
> >> - =C2=A0 =C2=A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_b=
uf_length);
> >> + =C2=A0 =C2=A0 unsigned int rfclen =3D get_rfc1002_length(server-=
>smallbuf);
> >> =C2=A0 =C2=A0 =C2=A0 int remaining =3D rfclen + 4 - server->total_=
read;
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata *rdata =3D mid->callback=
_data;
> >>
> >> @@ -1425,7 +1424,7 @@ cifs_readv_discard(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 length =3D cifs_r=
ead_from_socket(server, server->bigbuf,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 min_t(unsigned int, remaining,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFSMaxBufS=
ize + MAX_CIFS_HDR_SIZE));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFSMaxBufS=
ize + max_header_size()));
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (length < 0)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return length;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 server->total_rea=
d +=3D length;
> >> @@ -1436,14 +1435,35 @@ cifs_readv_discard(struct TCP_Server_Info =
*server, struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 return 0;
> >> =C2=A0}
> >>
> >> +static inline size_t
> >> +read_rsp_size(void)
> >> +{
> >> + =C2=A0 =C2=A0 return sizeof(READ_RSP);
> >> +}
> >> +
> >> +static inline unsigned int
> >> +read_data_offset(char *buf)
> >> +{
> >> + =C2=A0 =C2=A0 READ_RSP *rsp =3D (READ_RSP *)buf;
> >> + =C2=A0 =C2=A0 return le16_to_cpu(rsp->DataOffset);
> >> +}
> >> +
> >> +static inline unsigned int
> >> +read_data_length(char *buf)
> >> +{
> >> + =C2=A0 =C2=A0 READ_RSP *rsp =3D (READ_RSP *)buf;
> >> + =C2=A0 =C2=A0 return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0le16_to_cpu(rsp->DataLe=
ngth);
> >> +}
> >> +
> >> =C2=A0static int
> >> =C2=A0cifs_readv_receive(struct TCP_Server_Info *server, struct mi=
d_q_entry *mid)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 int length, len;
> >> =C2=A0 =C2=A0 =C2=A0 unsigned int data_offset, remaining, data_len=
;
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_readdata *rdata =3D mid->callback=
_data;
> >> - =C2=A0 =C2=A0 READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
> >> - =C2=A0 =C2=A0 unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_b=
uf_length) + 4;
> >> + =C2=A0 =C2=A0 char *buf =3D server->smallbuf;
> >> + =C2=A0 =C2=A0 unsigned int buflen =3D get_rfc1002_length(buf) + =
4;
> >> =C2=A0 =C2=A0 =C2=A0 u64 eof;
> >> =C2=A0 =C2=A0 =C2=A0 pgoff_t eof_index;
> >> =C2=A0 =C2=A0 =C2=A0 struct page *page, *tpage;
> >> @@ -1456,10 +1476,9 @@ cifs_readv_receive(struct TCP_Server_Info *=
server, struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* can if there's not enough data. At th=
is point, we've read down to
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* the Mid.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> - =C2=A0 =C2=A0 len =3D min_t(unsigned int, rfclen, sizeof(*rsp)) =
-
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sizeof(struct smb_hdr) + 1;
> >> + =C2=A0 =C2=A0 len =3D min_t(unsigned int, buflen, read_rsp_size(=
)) - header_size() + 1;
> >>
> >> - =C2=A0 =C2=A0 rdata->iov[0].iov_base =3D server->smallbuf + size=
of(struct smb_hdr) - 1;
> >> + =C2=A0 =C2=A0 rdata->iov[0].iov_base =3D buf + header_size() - 1=
;
> >> =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov_len =3D len;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 length =3D cifs_readv_from_socket(server, rda=
ta->iov, 1, len);
> >> @@ -1468,7 +1487,7 @@ cifs_readv_receive(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 server->total_read +=3D length;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* Was the SMB read successful? */
> >> - =C2=A0 =C2=A0 rdata->result =3D map_smb_to_linux_error(&rsp->hdr=
, false);
> >> + =C2=A0 =C2=A0 rdata->result =3D map_smb_to_linux_error(buf, fals=
e);
> >> =C2=A0 =C2=A0 =C2=A0 if (rdata->result !=3D 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: serv=
er returned error %d", __func__,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rdata->result);
> >> @@ -1476,14 +1495,14 @@ cifs_readv_receive(struct TCP_Server_Info =
*server, struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* Is there enough to get to the rest of the =
READ_RSP header? */
> >> - =C2=A0 =C2=A0 if (server->total_read < sizeof(READ_RSP)) {
> >> + =C2=A0 =C2=A0 if (server->total_read < read_rsp_size()) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: serv=
er returned short header. got=3D%u expected=3D%zu",
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 __func__, server->total_read, sizeof(READ_RSP));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 __func__, server->total_read, read_rsp_size());
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdata->result =3D=
 -EIO;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return cifs_readv=
_discard(server, mid);
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> - =C2=A0 =C2=A0 data_offset =3D le16_to_cpu(rsp->DataOffset) + 4;
> >> + =C2=A0 =C2=A0 data_offset =3D read_data_offset(buf) + 4;
> >> =C2=A0 =C2=A0 =C2=A0 if (data_offset < server->total_read) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* win2k8 so=
metimes sends an offset of 0 when the read
> >> @@ -1507,7 +1526,7 @@ cifs_readv_receive(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 len =3D data_offset - server->total_read;
> >> =C2=A0 =C2=A0 =C2=A0 if (len > 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* read any junk =
before data into the rest of smallbuf */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov_base=
 =3D server->smallbuf + server->total_read;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov_base=
 =3D buf + server->total_read;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov=
_len =3D len;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 length =3D cifs_r=
eadv_from_socket(server, rdata->iov, 1, len);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (length < 0)
> >> @@ -1516,15 +1535,14 @@ cifs_readv_receive(struct TCP_Server_Info =
*server, struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* set up first iov for signature check */
> >> - =C2=A0 =C2=A0 rdata->iov[0].iov_base =3D server->smallbuf;
> >> + =C2=A0 =C2=A0 rdata->iov[0].iov_base =3D buf;
> >> =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov_len =3D server->total_read;
> >> =C2=A0 =C2=A0 =C2=A0 cFYI(1, "0: iov_base=3D%p iov_len=3D%zu",
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdata->iov[0].iov=
_base, rdata->iov[0].iov_len);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* how much data is in the response? */
> >> - =C2=A0 =C2=A0 data_len =3D le16_to_cpu(rsp->DataLengthHigh) << 1=
6;
> >> - =C2=A0 =C2=A0 data_len +=3D le16_to_cpu(rsp->DataLength);
> >> - =C2=A0 =C2=A0 if (data_offset + data_len > rfclen) {
> >> + =C2=A0 =C2=A0 data_len =3D read_data_length(buf);
> >> + =C2=A0 =C2=A0 if (data_offset + data_len > buflen) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* data_len is co=
rrupt -- discard frame */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rdata->result =3D=
 -EIO;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return cifs_readv=
_discard(server, mid);
> >> @@ -1603,11 +1621,11 @@ cifs_readv_receive(struct TCP_Server_Info =
*server, struct mid_q_entry *mid)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 rdata->bytes =3D length;
> >>
> >> - =C2=A0 =C2=A0 cFYI(1, "total_read=3D%u rfclen=3D%u remaining=3D%=
u", server->total_read,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rfclen, remaining);
> >> + =C2=A0 =C2=A0 cFYI(1, "total_read=3D%u buflen=3D%u remaining=3D%=
u", server->total_read,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 buflen, remaining);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* discard anything left over */
> >> - =C2=A0 =C2=A0 if (server->total_read < rfclen)
> >> + =C2=A0 =C2=A0 if (server->total_read < buflen)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return cifs_readv=
_discard(server, mid);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 dequeue_mid(mid, false);
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 76cffc9..3d46493 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -338,18 +338,6 @@ requeue_echo:
> >> =C2=A0 =C2=A0 =C2=A0 queue_delayed_work(system_nrt_wq, &server->ec=
ho, SMB_ECHO_INTERVAL);
> >> =C2=A0}
> >>
> >> -static inline size_t
> >> -header_size(void)
> >> -{
> >> - =C2=A0 =C2=A0 return sizeof(struct smb_hdr);
> >> -}
> >> -
> >> -static inline size_t
> >> -max_header_size(void)
> >> -{
> >> - =C2=A0 =C2=A0 return MAX_CIFS_HDR_SIZE;
> >> -}
> >> -
> >> =C2=A0static bool
> >> =C2=A0allocate_buffers(struct TCP_Server_Info *server)
> >> =C2=A0{
> >> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> >> index 73e47e8..dd23a32 100644
> >> --- a/fs/cifs/netmisc.c
> >> +++ b/fs/cifs/netmisc.c
> >> @@ -836,8 +836,9 @@ ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, =
__u16 *ecode)
> >> =C2=A0}
> >>
> >> =C2=A0int
> >> -map_smb_to_linux_error(struct smb_hdr *smb, bool logErr)
> >> +map_smb_to_linux_error(char *buf, bool logErr)
> >> =C2=A0{
> >> + =C2=A0 =C2=A0 struct smb_hdr *smb =3D (struct smb_hdr *)buf;
> >> =C2=A0 =C2=A0 =C2=A0 unsigned int i;
> >> =C2=A0 =C2=A0 =C2=A0 int rc =3D -EIO; =C2=A0/* if transport error =
smb error may not be set */
> >> =C2=A0 =C2=A0 =C2=A0 __u8 smberrclass;
> >
> > You're changing the prototype of the above function, but are not
> > changing both of the callers. If you expect to pass different point=
er
> > types in there in the future, then it might be best to call it a vo=
id
> > pointer instead of a char?
>=20
> The first caller is cifs_readv_receive and it passes char pointer -
> ok. The second caller is cifs_check_receive - passes void pointer - o=
k
> too.
>=20

In my tree, cifs_check_receive does this:

	return map_smb_to_linux_error(mid->resp_buf, log_error);

=2E..and mid->resp_buf is:

        struct smb_hdr *resp_buf;       /* pointer to received SMB head=
er */

=2E..not a void pointer.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
