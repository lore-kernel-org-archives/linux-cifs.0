From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix regression during share-level security mounts
 (Repost)
Date: Thu, 20 Jan 2011 21:03:48 +0530
Message-ID: <4D3855DC.50505@suse.de>
References: <1295411634-18733-1-git-send-email-shirishpargaonkar@gmail.com> <4D36AFD5.1000001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D36AFD5.1000001-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/19/2011 03:03 PM, Suresh Jayaraman wrote:
> On 01/19/2011 10:03 AM, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> NTLM response length was changed to 16 bytes instead of 24 bytes
>> that are sent in Tree Connection Request during share-level security
>> share mounts.  Revert it back to 24 bytes.
>>
>>
>> Reported-and-Tested-by: Grzegorz Ozanski <grzegorz.ozanski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>> ---
>>  fs/cifs/connect.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> The patch looks OK to me going by:
> 	http://davenport.sourceforge.net/ntlm.html#theNtlmResponse
> 
> However, it's not clear to me which change modified this value to 16 and
> why? May be adding a commit id and little explanation in changelog to
> why it was modified to 16 would help?

Just for the record: the commit that unintentionally modified
CIFS_SESS_KEY_SIZE was 21e733930be6458e0c33482b6783e7c15ba984eb.
Thanks Shirish.

> 
> Acked-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> 
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 41f002f..cdba196 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2966,7 +2966,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
>>  		bcc_ptr++;              /* skip password */
>>  		/* already aligned so no need to do it below */
>>  	} else {
>> -		pSMB->PasswordLength = cpu_to_le16(CIFS_SESS_KEY_SIZE);
>> +		pSMB->PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
>>  		/* BB FIXME add code to fail this if NTLMv2 or Kerberos
>>  		   specified as required (when that support is added to
>>  		   the vfs in the future) as only NTLM or the much
>> @@ -2984,7 +2984,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInfo *ses,
>>  #endif /* CIFS_WEAK_PW_HASH */
>>  		SMBNTencrypt(tcon->password, ses->server->cryptkey, bcc_ptr);
>>  
>> -		bcc_ptr += CIFS_SESS_KEY_SIZE;
>> +		bcc_ptr += CIFS_AUTH_RESP_SIZE;
>>  		if (ses->capabilities & CAP_UNICODE) {
>>  			/* must align unicode strings */
>>  			*bcc_ptr = 0; /* null byte password */
> 

-- 
Suresh Jayaraman
