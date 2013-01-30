From: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
Subject: Re: [PATCH 1/1] cifs: set MAY_SIGN when sec=krb5
Date: Wed, 30 Jan 2013 20:03:55 +0100
Message-ID: <51096E9B.5080704@prodrive.nl>
References: <1351071946-21458-1-git-send-email-martijn.de.gouw@prodrive.nl> <20121024073723.2e5063db@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121024073723.2e5063db-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On 10/24/2012 01:37 PM, Jeff Layton wrote:
> On Wed, 24 Oct 2012 11:45:46 +0200
> Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org> wrote:
>
>> Setting this secFlg allows usage of dfs where some servers require
>> signing and others don't.
>>
>> Signed-off-by: Martijn de Gouw <martijn.de.gouw-BHYAuTpL47qEVqv0pETR8A@public.gmane.org>
>> ---
>> :100644 100644 b39bb4a... 4da9dd3... M	fs/cifs/connect.c
>>   fs/cifs/connect.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index b39bb4a..4da9dd3 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -994,7 +994,7 @@ static int cifs_parse_security_flavors(char *value,
>>
>>   	switch (match_token(value, cifs_secflavor_tokens, args)) {
>>   	case Opt_sec_krb5:
>> -		vol->secFlg |= CIFSSEC_MAY_KRB5;
>> +		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
>>   		break;
>>   	case Opt_sec_krb5i:
>>   		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
>
> Looks like a reasonable bandaid until someone overhauls the auth
> selection code for sanity...
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
>

It's been a while and this patch is not yet applied.
Please apply.

It is already in patchwork I saw:
https://patchwork.kernel.org/patch/1637021/

Regards, Martijn

-- 
Martijn de Gouw
Engineer
Prodrive B.V.
Mobile: +31 63 17 76 161
Phone:  +31 40 26 76 200
