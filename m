From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Mon, 25 Sep 2017 20:20:07 -0500
Message-ID: <CAH2r5mtSy5w6FWG3tJidfLQWOoWyqAg3Sq-MKNOen1wPiOW4Rw@mail.gmail.com>
References: <20170926105148.5e1553ec@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20170926105148.5e1553ec@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

fixed - repushed to cifs-2.6.git for-next

On Mon, Sep 25, 2017 at 7:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/smb2transport.c: In function 'generate_smb311signingkey':
> fs/cifs/smb2transport.c:403:27: error: 'struct cifs_ses' has no member named 'preauth_sha_hash'
>   d->context.iov_base = ses->preauth_sha_hash;
>                            ^
> fs/cifs/smb2transport.c:409:27: error: 'struct cifs_ses' has no member named 'preauth_sha_hash'
>   d->context.iov_base = ses->preauth_sha_hash;
>                            ^
> fs/cifs/smb2transport.c:415:27: error: 'struct cifs_ses' has no member named 'preauth_sha_hash'
>   d->context.iov_base = ses->preauth_sha_hash;
>                            ^
>
> Caused by commit
>
>   a679c0e328c9 ("Fix encryption labels and lengths for SMB3.1.1")
>
> This build has
>
> # CONFIG_CIFS_SMB311 is not set
>
> I have used the version of the cifs tree from next-20170922 for today.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
