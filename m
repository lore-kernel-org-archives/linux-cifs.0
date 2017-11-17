From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/19] cifs: remove rfc1002 header from smb2_negotiate_req
Date: Thu, 16 Nov 2017 17:47:27 -0800
Message-ID: <CAKywueT5uYKLr-9u6-YeJiqNfno7-arBVdXpix+ma44w26GvLQ@mail.gmail.com>
References: <20171109011433.14468-1-lsahlber@redhat.com> <20171109011433.14468-3-lsahlber@redhat.com>
 <CAKywueRFOZroCmp9nhr22PGE0R31peFr6j8A2mGVQSEP07bqLQ@mail.gmail.com> <1978629070.27950035.1510883055312.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1978629070.27950035.1510883055312.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-16 17:44 GMT-08:00 Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>
>
> ----- Original Message -----
> From: "Pavel Shilovsky" <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: "Ronnie Sahlberg" <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "linux-cifs" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Sent: Friday, 17 November, 2017 12:24:59 PM
> Subject: Re: [PATCH 02/19] cifs: remove rfc1002 header from smb2_negotiate_req
>
> 2017-11-08 17:14 GMT-08:00 Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/smb2pdu.c | 26 +++++++++++---------------
>>  fs/cifs/smb2pdu.h |  2 +-
>>  2 files changed, 12 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 5331631386a2..f5cf9953955c 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -398,8 +398,8 @@ small_smb2_init(__le16 smb2_command, struct cifs_tcon *tcon,
>>  }
>>
>>  #ifdef CONFIG_CIFS_SMB311
>> -/* offset is sizeof smb2_negotiate_req - 4 but rounded up to 8 bytes */
>> -#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) - 4 */
>> +/* offset is sizeof smb2_negotiate_req but rounded up to 8 bytes */
>> +#define OFFSET_OF_NEG_CONTEXT 0x68  /* sizeof(struct smb2_negotiate_req) */
>>
>>
>>  #define SMB2_PREAUTH_INTEGRITY_CAPABILITIES    cpu_to_le16(1)
>> @@ -429,9 +429,7 @@ build_encrypt_ctxt(struct smb2_encryption_neg_context *pneg_ctxt)
>>  static void
>>  assemble_neg_contexts(struct smb2_negotiate_req *req)
>>  {
>> -
>> -       /* +4 is to account for the RFC1001 len field */
>> -       char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT + 4;
>> +       char *pneg_ctxt = (char *)req + OFFSET_OF_NEG_CONTEXT;
>>
>>         build_preauth_ctxt((struct smb2_preauth_neg_context *)pneg_ctxt);
>>         /* Add 2 to size to round to 8 byte boundary */
>> @@ -439,8 +437,6 @@ assemble_neg_contexts(struct smb2_negotiate_req *req)
>>         build_encrypt_ctxt((struct smb2_encryption_neg_context *)pneg_ctxt);
>>         req->NegotiateContextOffset = cpu_to_le32(OFFSET_OF_NEG_CONTEXT);
>>         req->NegotiateContextCount = cpu_to_le16(2);
>> -       inc_rfc1001_len(req, 4 + sizeof(struct smb2_preauth_neg_context)
>> -                       + sizeof(struct smb2_encryption_neg_context)); /* calculate hash */
>
>> Why do we need to remove this?
>
> Because req no longer contains a rfc1002 length field any more.
>
> We now compute the rfc1002 length during smb2_send_recv() and thus we don't need to
> modify it using inc_rfc1001_len() any more.

Ok. I misread it. Makes sense then.

--
Best regards,
Pavel Shilovsky
