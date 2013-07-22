From: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] cifs: extend the buffer length enought for sprintf()
 using
Date: Mon, 22 Jul 2013 08:29:40 +0800
Message-ID: <51EC7CF4.8090704@asianux.com>
References: <51E5E9DA.8020603@asianux.com> <CAFB9KM2nJEt-O+o=4bkxNMJ2Fr0TfjkpRF=7B98=Lp9zFu8_og@mail.gmail.com> <CAH2r5msQEbQWpE+wqEoLY_++=ywDVoAg_vmWB3kJG8=ECHC3Pg@mail.gmail.com> <CAFB9KM0rEDyE6hb8t-gDLTDKq9kaRr4Bhs7SLBEZTnyH5u5U-A@mail.gmail.com> <51E74008.8050308@asianux.com> <CAFB9KM2MbLuETpoN9wafZLq6B9StjtXnG15G16uGcOcnRM8+sA@mail.gmail.com> <51E88FF0.2010101@asianux.com> <20130719064531.2a9836f5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130719064531.2a9836f5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/19/2013 06:45 PM, Jeff Layton wrote:
> On Fri, 19 Jul 2013 09:01:36 +0800
> Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> wrote:
> 
>> For cifs_set_cifscreds() in "fs/cifs/connect.c", 'desc' buffer length
>> is 'CIFSCREDS_DESC_SIZE' (56 is less than 256), and 'ses->domainName'
>> length may be "255 + '\0'".
>>
>> The related sprintf() may cause memory overflow, so need extend related
>> buffer enough to hold all things.
>>
>> It is also necessary to be sure of 'ses->domainName' must be less than
>> 256, and define the related macro instead of hard code number '256'.
>>
>> Signed-off-by: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
>> ---
>>  fs/cifs/cifsencrypt.c |    2 +-
>>  fs/cifs/cifsglob.h    |    1 +
>>  fs/cifs/connect.c     |    7 ++++---
>>  fs/cifs/sess.c        |    6 +++---
>>  4 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
>> index 45e57cc..bb84d7c 100644
>> --- a/fs/cifs/cifsencrypt.c
>> +++ b/fs/cifs/cifsencrypt.c
>> @@ -421,7 +421,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
>>  		if (blobptr + attrsize > blobend)
>>  			break;
>>  		if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
>> -			if (!attrsize)
>> +			if (!attrsize || attrsize >= MAX_DOMAINNAME_SIZE)
>>  				break;
>>  			if (!ses->domainName) {
>>  				ses->domainName =
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 33f17ed..64bb4c5 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -44,6 +44,7 @@
>>  #define MAX_TREE_SIZE (2 + MAX_SERVER_SIZE + 1 + MAX_SHARE_SIZE + 1)
>>  #define MAX_SERVER_SIZE 15
>>  #define MAX_SHARE_SIZE 80
>> +#define MAX_DOMAINNAME_SIZE 256	/* maximum fully qualified domain name (FQDN) */
>>  #define MAX_USERNAME_SIZE 256	/* reasonable maximum for current servers */
>>  #define MAX_PASSWORD_SIZE 512	/* max for windows seems to be 256 wide chars */
>>  
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index fa68813..3f9dcf7 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1675,7 +1675,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>>  			if (string == NULL)
>>  				goto out_nomem;
>>  
>> -			if (strnlen(string, 256) == 256) {
>> +			if (strnlen(string, MAX_DOMAINNAME_SIZE)
>> +					== MAX_DOMAINNAME_SIZE) {
>>  				printk(KERN_WARNING "CIFS: domain name too"
>>  						    " long\n");
>>  				goto cifs_parse_mount_err;
>> @@ -2276,8 +2277,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
>>  
>>  #ifdef CONFIG_KEYS
>>  
>> -/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
>> -#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
>> +/* strlen("cifs:a:") + MAX_DOMAINNAME_SIZE + 1 */
>> +#define CIFSCREDS_DESC_SIZE (7 + MAX_DOMAINNAME_SIZE + 1)
>>  
>>  /* Populate username and pw fields from keyring if possible */
>>  static int
>> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
>> index 79358e3..57b1537 100644
>> --- a/fs/cifs/sess.c
>> +++ b/fs/cifs/sess.c
>> @@ -197,7 +197,7 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
>>  		bytes_ret = 0;
>>  	} else
>>  		bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
>> -					    256, nls_cp);
>> +					    MAX_DOMAINNAME_SIZE, nls_cp);
>>  	bcc_ptr += 2 * bytes_ret;
>>  	bcc_ptr += 2;  /* account for null terminator */
>>  
>> @@ -255,8 +255,8 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
>>  
>>  	/* copy domain */
>>  	if (ses->domainName != NULL) {
>> -		strncpy(bcc_ptr, ses->domainName, 256);
>> -		bcc_ptr += strnlen(ses->domainName, 256);
>> +		strncpy(bcc_ptr, ses->domainName, MAX_DOMAINNAME_SIZE);
>> +		bcc_ptr += strnlen(ses->domainName, MAX_DOMAINNAME_SIZE);
>>  	} /* else we will send a null domain name
>>  	     so the server will default to its own domain */
>>  	*bcc_ptr = 0;
> 
> Looks good...
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> 

Thanks.

-- 
Chen Gang
