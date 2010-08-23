From: Miloslav Trmac <mitr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: crypto apis in cifs module allocating storage for character
 array during run-time vs. dynamic allocation
Date: Mon, 23 Aug 2010 18:39:17 -0400 (EDT)
Message-ID: <363759039.1172081282603157268.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <AANLkTikyVs+8-=v0--i7tQDCqFzk=r5DrCvx+UZkjaiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikyVs+8-=v0--i7tQDCqFzk=r5DrCvx+UZkjaiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

----- "Shirish Pargaonkar" <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Instead of determining and allocating a char array for use during usage of
> crypto_shash_* calls, would like to instead dynamically
> allocate (and free) storage for the duration of crypto calculation
> (crypto_shash_init,
> crypto_shash_update, and crypto_shash_final)
> But everytime I try, it results in some sort of oops in the cifs module.
Let me just suggest something, without trying it...

> +struct sdesc {
> +       struct shash_desc shash;
> +       char *ctx;
        char ctx[];
would be correct here.
> +};
And you need to allocate both shash_desc and "ctx" together as a single piece of memory - exactly mirror the memory layout of the original "sdesc" variable.
    Mirek
