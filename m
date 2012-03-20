From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 09/11] CIFS: Separate protocol-specific code from
 cifs_readv_receive code
Date: Tue, 20 Mar 2012 11:33:42 +0400
Message-ID: <CAKywueSvsb+BP7ktb0QEgL3WmrO8j42bicvd-WjWNro6qGRc7w@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-10-git-send-email-piastry@etersoft.ru>
	<20120319161728.1f8cec40@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120319161728.1f8cec40-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

20 =CD=C1=D2=D4=C1 2012=9A=C7. 0:17 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Fri, 16 Mar 2012 18:09:32 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/cifsglob.h =9A| =9A 12 ++++++++++
>> =9Afs/cifs/cifsproto.h | =9A =9A2 +-
>> =9Afs/cifs/cifssmb.c =9A | =9A 58 +++++++++++++++++++++++++++++++++-=
----------------
>> =9Afs/cifs/connect.c =9A | =9A 12 ----------
>> =9Afs/cifs/netmisc.c =9A | =9A =9A3 +-
>> =9A5 files changed, 53 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 34a897e..a403398 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -341,6 +341,18 @@ has_credits(struct TCP_Server_Info *server, int=
 *credits)
>> =9A =9A =9A return num > 0;
>> =9A}
>>
>> +static inline size_t
>> +header_size(void)
>> +{
>> + =9A =9A return sizeof(struct smb_hdr);
>> +}
>> +
>> +static inline size_t
>> +max_header_size(void)
>> +{
>> + =9A =9A return MAX_CIFS_HDR_SIZE;
>> +}
>> +
>> =9A/*
>> =9A * Macros to allow the TCP_Server_Info->net field and related cod=
e to drop out
>> =9A * when CONFIG_NET_NS isn't set.
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 15c9b59..db38a40 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -106,7 +106,7 @@ extern int cifs_convert_address(struct sockaddr =
*dst, const char *src, int len);
>> =9Aextern int cifs_set_port(struct sockaddr *addr, const unsigned sh=
ort int port);
>> =9Aextern int cifs_fill_sockaddr(struct sockaddr *dst, const char *s=
rc, int len,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A const un=
signed short int port);
>> -extern int map_smb_to_linux_error(struct smb_hdr *smb, bool logErr)=
;
>> +extern int map_smb_to_linux_error(char *buf, bool logErr);
>> =9Aextern void header_assemble(struct smb_hdr *, char /* command */ =
,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A const struct cif=
s_tcon *, int /* length of
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A fixed section (w=
ord count) in two byte units */);
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index d3b8089..765f804 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -1415,8 +1415,7 @@ cifs_readdata_free(struct cifs_readdata *rdata=
)
>> =9Astatic int
>> =9Acifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_e=
ntry *mid)
>> =9A{
>> - =9A =9A READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
>> - =9A =9A unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_buf_lengt=
h);
>> + =9A =9A unsigned int rfclen =3D get_rfc1002_length(server->smallbu=
f);
>> =9A =9A =9A int remaining =3D rfclen + 4 - server->total_read;
>> =9A =9A =9A struct cifs_readdata *rdata =3D mid->callback_data;
>>
>> @@ -1425,7 +1424,7 @@ cifs_readv_discard(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
>>
>> =9A =9A =9A =9A =9A =9A =9A length =3D cifs_read_from_socket(server,=
 server->bigbuf,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A min_t(un=
signed int, remaining,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A=
 =9A CIFSMaxBufSize + max_header_size()));
>> =9A =9A =9A =9A =9A =9A =9A if (length < 0)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return length;
>> =9A =9A =9A =9A =9A =9A =9A server->total_read +=3D length;
>> @@ -1436,14 +1435,35 @@ cifs_readv_discard(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
>> =9A =9A =9A return 0;
>> =9A}
>>
>> +static inline size_t
>> +read_rsp_size(void)
>> +{
>> + =9A =9A return sizeof(READ_RSP);
>> +}
>> +
>> +static inline unsigned int
>> +read_data_offset(char *buf)
>> +{
>> + =9A =9A READ_RSP *rsp =3D (READ_RSP *)buf;
>> + =9A =9A return le16_to_cpu(rsp->DataOffset);
>> +}
>> +
>> +static inline unsigned int
>> +read_data_length(char *buf)
>> +{
>> + =9A =9A READ_RSP *rsp =3D (READ_RSP *)buf;
>> + =9A =9A return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
>> + =9A =9A =9A =9A =9A =9Ale16_to_cpu(rsp->DataLength);
>> +}
>> +
>> =9Astatic int
>> =9Acifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_e=
ntry *mid)
>> =9A{
>> =9A =9A =9A int length, len;
>> =9A =9A =9A unsigned int data_offset, remaining, data_len;
>> =9A =9A =9A struct cifs_readdata *rdata =3D mid->callback_data;
>> - =9A =9A READ_RSP *rsp =3D (READ_RSP *)server->smallbuf;
>> - =9A =9A unsigned int rfclen =3D be32_to_cpu(rsp->hdr.smb_buf_lengt=
h) + 4;
>> + =9A =9A char *buf =3D server->smallbuf;
>> + =9A =9A unsigned int buflen =3D get_rfc1002_length(buf) + 4;
>> =9A =9A =9A u64 eof;
>> =9A =9A =9A pgoff_t eof_index;
>> =9A =9A =9A struct page *page, *tpage;
>> @@ -1456,10 +1476,9 @@ cifs_readv_receive(struct TCP_Server_Info *se=
rver, struct mid_q_entry *mid)
>> =9A =9A =9A =9A* can if there's not enough data. At this point, we'v=
e read down to
>> =9A =9A =9A =9A* the Mid.
>> =9A =9A =9A =9A*/
>> - =9A =9A len =3D min_t(unsigned int, rfclen, sizeof(*rsp)) -
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A sizeof(struct smb_hdr) + 1=
;
>> + =9A =9A len =3D min_t(unsigned int, buflen, read_rsp_size()) - hea=
der_size() + 1;
>>
>> - =9A =9A rdata->iov[0].iov_base =3D server->smallbuf + sizeof(struc=
t smb_hdr) - 1;
>> + =9A =9A rdata->iov[0].iov_base =3D buf + header_size() - 1;
>> =9A =9A =9A rdata->iov[0].iov_len =3D len;
>>
>> =9A =9A =9A length =3D cifs_readv_from_socket(server, rdata->iov, 1,=
 len);
>> @@ -1468,7 +1487,7 @@ cifs_readv_receive(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
>> =9A =9A =9A server->total_read +=3D length;
>>
>> =9A =9A =9A /* Was the SMB read successful? */
>> - =9A =9A rdata->result =3D map_smb_to_linux_error(&rsp->hdr, false)=
;
>> + =9A =9A rdata->result =3D map_smb_to_linux_error(buf, false);
>> =9A =9A =9A if (rdata->result !=3D 0) {
>> =9A =9A =9A =9A =9A =9A =9A cFYI(1, "%s: server returned error %d", =
__func__,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A rdata->result);
>> @@ -1476,14 +1495,14 @@ cifs_readv_receive(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
>> =9A =9A =9A }
>>
>> =9A =9A =9A /* Is there enough to get to the rest of the READ_RSP he=
ader? */
>> - =9A =9A if (server->total_read < sizeof(READ_RSP)) {
>> + =9A =9A if (server->total_read < read_rsp_size()) {
>> =9A =9A =9A =9A =9A =9A =9A cFYI(1, "%s: server returned short heade=
r. got=3D%u expected=3D%zu",
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __func__, server->total_re=
ad, sizeof(READ_RSP));
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A __func__, server->total_re=
ad, read_rsp_size());
>> =9A =9A =9A =9A =9A =9A =9A rdata->result =3D -EIO;
>> =9A =9A =9A =9A =9A =9A =9A return cifs_readv_discard(server, mid);
>> =9A =9A =9A }
>>
>> - =9A =9A data_offset =3D le16_to_cpu(rsp->DataOffset) + 4;
>> + =9A =9A data_offset =3D read_data_offset(buf) + 4;
>> =9A =9A =9A if (data_offset < server->total_read) {
>> =9A =9A =9A =9A =9A =9A =9A /*
>> =9A =9A =9A =9A =9A =9A =9A =9A* win2k8 sometimes sends an offset of=
 0 when the read
>> @@ -1507,7 +1526,7 @@ cifs_readv_receive(struct TCP_Server_Info *ser=
ver, struct mid_q_entry *mid)
>> =9A =9A =9A len =3D data_offset - server->total_read;
>> =9A =9A =9A if (len > 0) {
>> =9A =9A =9A =9A =9A =9A =9A /* read any junk before data into the re=
st of smallbuf */
>> - =9A =9A =9A =9A =9A =9A rdata->iov[0].iov_base =3D server->smallbu=
f + server->total_read;
>> + =9A =9A =9A =9A =9A =9A rdata->iov[0].iov_base =3D buf + server->t=
otal_read;
>> =9A =9A =9A =9A =9A =9A =9A rdata->iov[0].iov_len =3D len;
>> =9A =9A =9A =9A =9A =9A =9A length =3D cifs_readv_from_socket(server=
, rdata->iov, 1, len);
>> =9A =9A =9A =9A =9A =9A =9A if (length < 0)
>> @@ -1516,15 +1535,14 @@ cifs_readv_receive(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
>> =9A =9A =9A }
>>
>> =9A =9A =9A /* set up first iov for signature check */
>> - =9A =9A rdata->iov[0].iov_base =3D server->smallbuf;
>> + =9A =9A rdata->iov[0].iov_base =3D buf;
>> =9A =9A =9A rdata->iov[0].iov_len =3D server->total_read;
>> =9A =9A =9A cFYI(1, "0: iov_base=3D%p iov_len=3D%zu",
>> =9A =9A =9A =9A =9A =9A =9A rdata->iov[0].iov_base, rdata->iov[0].io=
v_len);
>>
>> =9A =9A =9A /* how much data is in the response? */
>> - =9A =9A data_len =3D le16_to_cpu(rsp->DataLengthHigh) << 16;
>> - =9A =9A data_len +=3D le16_to_cpu(rsp->DataLength);
>> - =9A =9A if (data_offset + data_len > rfclen) {
>> + =9A =9A data_len =3D read_data_length(buf);
>> + =9A =9A if (data_offset + data_len > buflen) {
>> =9A =9A =9A =9A =9A =9A =9A /* data_len is corrupt -- discard frame =
*/
>> =9A =9A =9A =9A =9A =9A =9A rdata->result =3D -EIO;
>> =9A =9A =9A =9A =9A =9A =9A return cifs_readv_discard(server, mid);
>> @@ -1603,11 +1621,11 @@ cifs_readv_receive(struct TCP_Server_Info *s=
erver, struct mid_q_entry *mid)
>>
>> =9A =9A =9A rdata->bytes =3D length;
>>
>> - =9A =9A cFYI(1, "total_read=3D%u rfclen=3D%u remaining=3D%u", serv=
er->total_read,
>> - =9A =9A =9A =9A =9A =9A rfclen, remaining);
>> + =9A =9A cFYI(1, "total_read=3D%u buflen=3D%u remaining=3D%u", serv=
er->total_read,
>> + =9A =9A =9A =9A =9A =9A buflen, remaining);
>>
>> =9A =9A =9A /* discard anything left over */
>> - =9A =9A if (server->total_read < rfclen)
>> + =9A =9A if (server->total_read < buflen)
>> =9A =9A =9A =9A =9A =9A =9A return cifs_readv_discard(server, mid);
>>
>> =9A =9A =9A dequeue_mid(mid, false);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 76cffc9..3d46493 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -338,18 +338,6 @@ requeue_echo:
>> =9A =9A =9A queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECH=
O_INTERVAL);
>> =9A}
>>
>> -static inline size_t
>> -header_size(void)
>> -{
>> - =9A =9A return sizeof(struct smb_hdr);
>> -}
>> -
>> -static inline size_t
>> -max_header_size(void)
>> -{
>> - =9A =9A return MAX_CIFS_HDR_SIZE;
>> -}
>> -
>> =9Astatic bool
>> =9Aallocate_buffers(struct TCP_Server_Info *server)
>> =9A{
>> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
>> index 73e47e8..dd23a32 100644
>> --- a/fs/cifs/netmisc.c
>> +++ b/fs/cifs/netmisc.c
>> @@ -836,8 +836,9 @@ ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, __=
u16 *ecode)
>> =9A}
>>
>> =9Aint
>> -map_smb_to_linux_error(struct smb_hdr *smb, bool logErr)
>> +map_smb_to_linux_error(char *buf, bool logErr)
>> =9A{
>> + =9A =9A struct smb_hdr *smb =3D (struct smb_hdr *)buf;
>> =9A =9A =9A unsigned int i;
>> =9A =9A =9A int rc =3D -EIO; =9A/* if transport error smb error may =
not be set */
>> =9A =9A =9A __u8 smberrclass;
>
> You're changing the prototype of the above function, but are not
> changing both of the callers. If you expect to pass different pointer
> types in there in the future, then it might be best to call it a void
> pointer instead of a char?

The first caller is cifs_readv_receive and it passes char pointer -
ok. The second caller is cifs_check_receive - passes void pointer - ok
too.

--=20
Best regards,
Pavel Shilovsky.
