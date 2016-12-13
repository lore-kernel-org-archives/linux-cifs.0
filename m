From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH] cifs: Fix smbencrypt() to stop pointing a scatterlist at
 the stack
Date: Tue, 13 Dec 2016 14:40:17 +0300
Message-ID: <74b22139-4583-5bab-3916-4a32db81803e@cogentembedded.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <308cdb484648f98f6f0ad9feefd8acb2fe003aaf.1481575835.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        linux-cifs@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <308cdb484648f98f6f0ad9feefd8acb2fe003aaf.1481575835.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hello!

On 12/12/2016 11:54 PM, Andy Lutomirski wrote:

> smbencrypt() points a scatterlist to the stack, which is breaks if

    s/is//.

> CONFIG_VMAP_STACK=y.
>
> Fix it by switching to crypto_cipher_encrypt_one().  The new code
> should be considerably faster as an added benefit.
>
> This code is nearly identical to some code that Eric Biggers
> suggested.
>
> Cc: stable@vger.kernel.org # 4.9 only
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
[...]

MBR, Sergei
