From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH][SMB3] Cleanup sparse file support by creating worker
 function for it
Date: Fri, 15 Aug 2014 23:04:24 -0500
Message-ID: <CAH2r5mvEKDsP+svDMQq4UdS-+Og744s3suYbUWFLf7eU4yZT1w@mail.gmail.com>
References: <CAH2r5msUgxmikvOmirUfceCubUek8+AaCv6RcJoU6mcrJ9j=sg@mail.gmail.com>
 <20140815115152.6e20e542@f163.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>
To: David Disseldorp <ddiss@suse.de>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20140815115152.6e20e542@f163.suse.de>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Cleaned up and merged into cifs-2.6.git - thx

On Fri, Aug 15, 2014 at 4:51 AM, David Disseldorp <ddiss@suse.de> wrote:
> On Thu, 14 Aug 2014 16:44:15 -0500, Steve French wrote:
>
>> Simply move code to new function (for clarity).  The new function
>> sets or clears the sparse file attribute flag.
>>
>> Signed-off-by: Steve French <smfrench@gmail.com>
>> ---
>>  fs/cifs/smb2ops.c | 82 ++++++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 51 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 7463436..04a86cc 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -731,6 +731,54 @@ smb2_sync_write(const unsigned int xid, struct
>> cifsFileInfo *cfile,
>>      return SMB2_write(xid, parms, written, iov, nr_segs);
>>  }
>>
>> +/* Set or clear the SPARSE_FILE attribute based on value passed in setsparse */
>> +static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>> +        struct cifsFileInfo *cfile, struct inode *inode, __u8 setsparse)
>> +{
>> +    struct cifsInodeInfo *cifsi;
>> +    int rc;
>> +
>> +    cifsi = CIFS_I(inode);
>> +
>> +    /* if file already sparse don't bother setting sparse again */
>> +    if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && setsparse)
>> +        return true; /* already sparse */
>> +
>> +    if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && !setsparse)
>> +        return true; /* already not sparse */
>> +
>> +
>
> Drop one of the empty lines above. Looks good otherwise.
>
> Reviewed-by: David Disseldorp <ddiss@samba.org>
>
> Cheers, David



-- 
Thanks,

Steve
