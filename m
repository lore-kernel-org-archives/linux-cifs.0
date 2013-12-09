From: Tim Gardner <timg@tpi.com>
Subject: Re: [PATCH 4/5 linux-next V2] cifs: fix incorrect reference count
 check
Date: Mon, 09 Dec 2013 12:21:09 -0700
Message-ID: <52A61825.5060104@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>	<1386536924-51726-4-git-send-email-timg@tpi.com> <20131209060321.030be558@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Dean Gehnert <deang@tpi.com>, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20131209060321.030be558@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On 12/09/2013 04:03 AM, Jeff Layton wrote:
> On Sun,  8 Dec 2013 14:08:43 -0700
> Tim Gardner <timg@tpi.com> wrote:
> 
>> The reference count on tlink can only be decremented if
>> cifs_sb_tlink(cifs_sb) was used to acquire it. That only
>> happens if open_file==NULL.
>>
>> Cc: Steve French <sfrench@samba.org>
>> Cc: Jeff Layton <jlayton@redhat.com>
>> Cc: Dean Gehnert <deang@tpi.com>
>> Signed-off-by: Tim Gardner <timg@tpi.com>
>> ---
>>
>> V2 - this is a new patch in the V2 series.
>>
>>  fs/cifs/inode.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 3f710c6..e332038 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -2007,7 +2007,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>>  			CIFSSMBClose(xid, tcon, netfid);
>>  		}
>>  	}
>> -	if (tlink)
>> +	if (!open_file)
>>  		cifs_put_tlink(tlink);
>>  
>>  set_size_out:
> 
> 
> I don't see the bug here...
> 
> The only place tlink gets set to a non-NULL value is where
> cifs_sb_tlink gets called. Am I missing something?
> 

Nope - I think you're correct. For some reason I thought tlink was set
inside the 'if (openfile) {...}' clause. I'll drop this patch from the
V3 series.

rtg
-- 
Tim Gardner timg@tpi.com www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
