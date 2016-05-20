From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the security tree
Date: Thu, 19 May 2016 22:07:10 -0500
Message-ID: <CAH2r5mvJdYUFtQBkWqLQvOKSNUdK8YSGDRfpowiEffN9iTO3EQ@mail.gmail.com>
References: <20160519140120.23b345a1@canb.auug.org.au> <20160520091447.1cba4885@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: James Morris <jmorris@namei.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Sachin Prabhu <sprabhu@redhat.com>,
	David Howells <dhowells@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20160520091447.1cba4885@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

I fixed the build break (and some trivial compile warnings) due to the
change to the format of keyring_alloc and repushed the *"cifs: Create
dedicated keyring for spnego operations" patch to cifs-2.6.git
for-next

On Thu, May 19, 2016 at 6:14 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Steve,
>
> On Thu, 19 May 2016 14:01:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the security tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> fs/cifs/cifs_spnego.c: In function 'init_cifs_spnego':
>> fs/cifs/cifs_spnego.c:206:12: error: too few arguments to function 'keyring_alloc'
>>   keyring = keyring_alloc(".cifs_spnego",
>>             ^
>> In file included from include/linux/cred.h:17:0,
>>                  from include/linux/sched.h:56,
>>                  from include/linux/kasan.h:4,
>>                  from include/linux/slab.h:118,
>>                  from fs/cifs/cifs_spnego.c:23:
>> include/linux/key.h:302:20: note: declared here
>>  extern struct key *keyring_alloc(const char *description, kuid_t uid, kgid_t gid,
>>                     ^
>>
>> Caused by commit
>>
>>   5b82c5cbcfe4 ("cifs: Create dedicated keyring for spnego operations")
>>
>> from the cifs tree interacting with commit
>>
>>   5ac7eace2d00 ("KEYS: Add a facility to restrict new links into a keyring")
>>
>> from the security tree.
>>
>> I added the following merge fix patch (and someone will have to let
>> Linus know):
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Thu, 19 May 2016 13:45:10 +1000
>> Subject: [PATCH] cifs: fix for keyringalloc() API change
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  fs/cifs/cifs_spnego.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
>> index 248ab431930c..9ef0dfcb2f95 100644
>> --- a/fs/cifs/cifs_spnego.c
>> +++ b/fs/cifs/cifs_spnego.c
>> @@ -207,7 +207,7 @@ init_cifs_spnego(void)
>>                               GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
>>                               (KEY_POS_ALL & ~KEY_POS_SETATTR) |
>>                               KEY_USR_VIEW | KEY_USR_READ,
>> -                             KEY_ALLOC_NOT_IN_QUOTA, NULL);
>> +                             KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
>>       if (IS_ERR(keyring)) {
>>               ret = PTR_ERR(keyring);
>>               goto failed_put_cred;
>> --
>> 2.7.0
>
> The security tree has now been merged into Linus' tree, so this build
> breakage occurs when I merge the cifs tree.  So you will need to tell
> Linus about this needed fixup when he merges the cifs tree.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
