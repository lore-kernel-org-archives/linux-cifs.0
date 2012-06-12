From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs: fix parsing of password mount option
Date: Tue, 12 Jun 2012 07:19:25 +0530
Message-ID: <4FD6A025.3040701@suse.com>
References: <4FD60F7E.2060608@suse.com> <1339438697.2459.21.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339438697.2459.21.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 06/11/2012 11:48 PM, Sachin Prabhu wrote:
> On Mon, 2012-06-11 at 21:02 +0530, Suresh Jayaraman wrote:
>> The double delimiter check that allows a comma in the password parsing code is
>> unconditional. We set "tmp_end" to the end of the string and we continue to
>> check for double delimiter. In the case where the password doesn't contain a
>> comma we end up setting tmp_end to NULL and eventually setting "options" to
>> "end". This results in the premature termination of the options string and hence
>> the values of UNCip and UNC are being set to NULL. This results in mount failure
>> with "Connecting to DFS root not implemented yet" error.
>>
>> This error is usually not noticable as we have password as the last option in
>> the superblock mountdata. But when we call expand_dfs_referral() from
>> cifs_mount() and try to compose mount options for the submount, the resulting
>> mountdata will be of the form 
>>
>>    ",ver=1,user=foo,pass=bar,ip=x.x.x.x,unc=\\server\share"
>>
>> and hence results in the above error. This bug has been seen with older NAS
>> servers running Samba 3.0.24.
>>
>> Fix this by moving the double delimiter check inside the conditional loop.
>> Also move the assignment of temp_len above so that we need not call
>> strlen(value) twice.
>>
>> Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
>> ---
>>  fs/cifs/connect.c |   37 ++++++++++++++++++++-----------------
>>  1 files changed, 20 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 78db68a..fdbbb56 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1646,34 +1646,37 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>>  			value = strchr(data, '=');
>>  			value++;
>>  
>> +			temp_len = strlen(value);
>> +
>>  			/* Set tmp_end to end of the string */
>> -			tmp_end = (char *) value + strlen(value);
>> +			tmp_end = (char *) value + temp_len;
>>  
>>  			/* Check if following character is the deliminator
>>  			 * If yes, we have encountered a double deliminator
>>  			 * reset the NULL character to the deliminator
>>  			 */
>> -			if (tmp_end < end && tmp_end[1] == delim)
>> +			if (tmp_end < end && tmp_end[1] == delim) {
>>  				tmp_end[0] = delim;
>>  
>> -			/* Keep iterating until we get to a single deliminator
>> -			 * OR the end
>> -			 */
>> -			while ((tmp_end = strchr(tmp_end, delim)) != NULL &&
>> -			       (tmp_end[1] == delim)) {
>> -				tmp_end = (char *) &tmp_end[2];
>> -			}
>> +				/* Keep iterating until we get to a single
>> +				 * deliminator OR the end
>> +				 */
>> +				while ((tmp_end = strchr(tmp_end, delim))
>> +					!= NULL && (tmp_end[1] == delim)) {
>> +						tmp_end = (char *) &tmp_end[2];
>> +				}
>>  
>> -			/* Reset var options to point to next element */
>> -			if (tmp_end) {
>> -				tmp_end[0] = '\0';
>> -				options = (char *) &tmp_end[1];
>> -			} else
>> -				/* Reached the end of the mount option string */
>> -				options = end;
>> +				/* Reset var options to point to next element */
>> +				if (tmp_end) {
>> +					tmp_end[0] = '\0';
>> +					options = (char *) &tmp_end[1];
>> +				} else
>> +					/* Reached the end of the mount option
>> +					 * string */
>> +					options = end;
>> +			}
>>  
>>  			/* Now build new password string */
>> -			temp_len = strlen(value);
> 
> The bug fix is correct but you cannot optimise the second strlen() call
> in this manner since at this point if we had encountered a double
> delimiter the end of the value string is shifted down further until we

Doh, you're right. I'll respin the fixed one.
