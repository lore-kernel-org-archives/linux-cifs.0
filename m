From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: check kmalloc before use
Date: Thu, 23 Aug 2018 15:06:22 -0500
Message-ID: <CAH2r5muTn2+yP6wdcadGe9WRX6Zr91kdVz29Rh3EcCbuvr4CuQ@mail.gmail.com>
References: <1535019842-18103-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: hofrat@osadl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535019842-18103-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

merged into cifs-2.6.git for-next
On Thu, Aug 23, 2018 at 11:02 AM Nicholas Mc Guire <hofrat@osadl.org> wrote:
>
> The kmalloc was not being checked - if it fails issue a warning
> and return -ENOMEM to the caller.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> Fixes: b8da344b74c8 ("cifs: dynamic allocation of ntlmssp blob")
> ---
>
> Problem was located with an experimental coccinelle script
>
> Both call-sites will expect non-0 to indicate error so -ENOMEM
> should be OK here. Setting buflen to 0 seems to be the expected
> behavior on failure although it will not be checked/used at
> the call-sites - probably this could be removed here as well as
> in the handling of authentication error (preceding this change)
> it was just retained for consistency.
>
> Patch was compile tested with: x86_64_defconfig + CONFIG_CIFS=y
> (with sparse and smatch warning unrelated to proposed change)
>
> Patch is against 4.18 (localversion-next is next-20180823)
>
>  fs/cifs/sess.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 8b0502c..aa23c00 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -398,6 +398,12 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
>                 goto setup_ntlmv2_ret;
>         }
>         *pbuffer = kmalloc(size_of_ntlmssp_blob(ses), GFP_KERNEL);
> +       if (!*pbuffer) {
> +               rc = -ENOMEM;
> +               cifs_dbg(VFS, "Error %d during NTLMSSP allocation\n", rc);
> +               *buflen = 0;
> +               goto setup_ntlmv2_ret;
> +       }
>         sec_blob = (AUTHENTICATE_MESSAGE *)*pbuffer;
>
>         memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
> --
> 2.1.4
>


-- 
Thanks,

Steve
