From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Wed, 10 Nov 2010 13:34:53 +0530
Message-ID: <4CDA5225.8000309@suse.de>
References: <4CC65859.7040100@nttcom.co.jp>	<4CC6642F.2040401@suse.de>	<4CCA6FD3.4060907@nttcom.co.jp>	<4CCA7177.40303@suse.de>	<4CCF5DF8.9030809@nttcom.co.jp>	<4CD12521.2020708@suse.de>	<4CD35A27.4050605@nttcom.co.jp>	<AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0@mail.gmail.com>	<4CD76751.8010700@nttcom.co.jp>	<AANLkTimx3ukvAjmuf5KQ3dSLVhpaF51pXcOfS1E_iFhY@mail.gmail.com>	<4CD784AB.3040805@suse.de>	<4CD8C4E6.5080603@nttcom.co.jp> <AANLkTikeNCCoMTsnaMMs6jqivgbke9hTUx_25hosM=-9@mail.gmail.com> <4CDA4E5C.90004@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CDA4E5C.90004-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/10/2010 01:18 PM, Shinnosuke Yagi wrote:
> 
> I added some logging messages.
> 
> # git diff fs/smb2/smb2fs.c
> diff --git a/fs/smb2/smb2fs.c b/fs/smb2/smb2fs.c
> index aa550a3..52c9f35 100644
> --- a/fs/smb2/smb2fs.c
> +++ b/fs/smb2/smb2fs.c
> @@ -57,7 +57,7 @@ static struct quotactl_ops smb2_quotactl_ops;
> 
>  /* Definitions of various global variables follow */
> 
> -int smb2FYI;
> +int smb2FYI = 1;
>  int smb2ERROR = 1;
>  int trace_SMB2;
> 
> I got following logs on dmesg.
> ====================================================
> FS-Cache: Netfs 'smb2' registered for caching
> fs/smb2/smb2fs.c: SMB2_max_buf_size 0x4000
> fs/smb2/smb2fs.c: smb2_init_request_bufs 0
> fs/smb2/smb2fs.c: register_filesystem 0
> fs/smb2/smb2fs.c: register_key_type -17

-17 is -EEXIST which means ket type with the name is already present.
The below patch should fix the problem I think. Could you try and
report back?


From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] smb2: rename smb2 spnego key type

.. to avoid key registration failure. register_key_type() doesn't allow key
types with same names.

Reported-by: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/smb2/smb2_spnego.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/smb2/smb2_spnego.c b/fs/smb2/smb2_spnego.c
index 6551002..24df95a 100644
--- a/fs/smb2/smb2_spnego.c
+++ b/fs/smb2/smb2_spnego.c
@@ -61,7 +61,7 @@ smb2_spnego_key_destroy(struct key *key)
  * keytype for SMB2 spnego keys
  */
 struct key_type smb2_spnego_key_type = {
-	.name		= "cifs.spnego",
+	.name		= "smb2.spnego",
 	.instantiate	= smb2_spnego_key_instantiate,
 	.match		= user_match,
 	.destroy	= smb2_spnego_key_destroy,
