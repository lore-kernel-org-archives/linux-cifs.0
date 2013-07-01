From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Limiting allocation of smb2 crypto structs to smb2 mounts
Date: Sun, 30 Jun 2013 22:58:17 -0500
Message-ID: <CAH2r5mt3qJLzgM16a6ss20nau=xaNUESsfFHVcBp6hjWXZy0Jw@mail.gmail.com>
References: <CAH2r5msin0gn6xDGgm9b7nejUY20wxJKcEFRakPc9QF0FR3r9w@mail.gmail.com>
	<CADT32eL69Kms70ko-K7M_t=nPESv1i_E-2j+Nc2bWA+j+JA+Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eL69Kms70ko-K7M_t=nPESv1i_E-2j+Nc2bWA+j+JA+Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jun 30, 2013 at 10:55 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Jun 30, 2013 at 2:10 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Updated patch to try to prevent allocation of smb2 or smb3 crypto
>> secmech structures unless needed.  There is probably more updates that
>> could be done to cleanup cifs - but the more important part is to get
>> the smb2/smb3 part cleaned up.
>>
<snip>>
>>  int
>>  smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>>  {
>> @@ -52,6 +111,9 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
>> TCP_Server_Info *server)
>>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
>>         memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
>>
>> +       if (server->secmech.hmacsha256 == NULL)
>> +               smb2_crypto_shash_allocate(server);
>> +
>
> I think we should check for error here
>
>>         rc = crypto_shash_setkey(server->secmech.hmacsha256,
>>                 server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>>         if (rc) {
>> @@ -129,6 +191,10 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
>>         memset(prfhash, 0x0, SMB2_HMACSHA256_SIZE);
>>         memset(server->smb3signingkey, 0x0, SMB3_SIGNKEY_SIZE);
>>
>> +       /* SMB3 essentially requires signing so no harm allocating it early */
>> +       if (server->secmech.hmacsha256 == NULL)
>> +               smb3_crypto_shash_allocate(server);
>> +
>
> This should be smb2_crypto_shash_allocate(sever), with error checked.
>
>>         rc = crypto_shash_setkey(server->secmech.hmacsha256,
>>                 server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
>>         if (rc) {
>> @@ -210,6 +276,9 @@ smb3_calc_signature(struct smb_rqst *rqst, struct
>> TCP_Server_Info *server)
>>                 return rc;
>>         }
>>
>> +       /* we already allocate sdesccmacaes when we init smb3 signing key,
>> +          so unlike smb2 we do not have to check here if secmech
>> +          are initialized */
>
> I do not see code to allocate cmac-aes.  I think we should do it in
> function smb3_calc_signature.  cmac-aes is not needed to generate the
> smb3 signing key.
> So there should be this call with error checked.
>
>           if (server->secmech.cmacaes == NULL)
>              smb3_crypto_shash_allocate(server);
>

Yes


-- 
Thanks,

Steve
