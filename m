From: Anton Protopopov <a.s.protopopov@gmail.com>
Subject: Re: [PATCH] cifs: fix erroneous return value
Date: Wed, 10 Feb 2016 13:53:07 -0500
Message-ID: <CAG0P6payBGQO97ZqyJGKaxdjfj6181LcY2kzq_UpEBFPnOhYkQ@mail.gmail.com>
References: <1455126621-28052-1-git-send-email-a.s.protopopov@gmail.com>
	<1455127186.3333.44.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455127186.3333.44.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2016-02-10 12:59 GMT-05:00 Joe Perches <joe@perches.com>:
> On Wed, 2016-02-10 at 12:50 -0500, Anton Protopopov wrote:
>> The setup_ntlmv2_rsp() function may return positive value ENOMEM instead
>> of -ENOMEM in case of kmalloc failure.
>
> How have you verified this change is correct?

Yes, this is the only case in which the setup_ntlmv2_rsp() function
returns positive error value. In all other error cases it returns the
negative error number.

>
> Have you checked that the callers of this function in
> fs/cifs/sess.c do the appropriate things with with a
> negative return value?
>
> The return value is now set into a struct member variable
> as a positive value,
>
>         sess_data->result = rc;

As far as I can see, this member variable always contains a negative
error value which, in the end, is returned by the CIFS_SessSetup()
function (this function can also return -EINVAL, -ENOMEM, -EOPNOTSUPP,
etc.).

> Have you checked all the users of this member variable?
>
> If you have, you should say so in the commit message.
>
>> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
>> ---
>>  fs/cifs/cifsencrypt.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index afa09fc..e682b36 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -714,7 +714,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>>
>>       ses->auth_key.response = kmalloc(baselen + tilen, GFP_KERNEL);
>>       if (!ses->auth_key.response) {
>> -             rc = ENOMEM;
>> +             rc = -ENOMEM;
>>               ses->auth_key.len = 0;
>>               goto setup_ntlmv2_rsp_ret;
>>       }
>
