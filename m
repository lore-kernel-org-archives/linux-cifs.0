From: Steve French <smfrench@gmail.com>
Subject: Re: [smb3] unreachable code and memory leaks
Date: Mon, 18 Jun 2018 11:55:43 -0500
Message-ID: <CAH2r5muZJkx0eR0uAyuRBkkTf7-97x5oSMWPXdfb1TUK4rwGJw@mail.gmail.com>
References: <20180618130737.GA13880@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180618130737.GA13880@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Jun 18, 2018 at 8:07 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> Hi Steve,
>
> While doing some static analysis I came across the following piece of code at fs/cifs/smb2pdu.c:2017:
>
> 2017                if (n_iov > 2) {
> 2018                        struct create_context *ccontext =
> 2019                            (struct create_context *)iov[n_iov-1].iov_base;
> 2020                        ccontext->Next =
> 2021                                cpu_to_le32(iov[n_iov-1].iov_len);
> 2022                }

Good catch - this is harmless (and experimental mount option) - cut
and paste - unneeded clause.
Fixing now


> Also, it seems there are multiple places in which memory allocated for *path* is leaking:
>
> 1946        else
> 1947                return -EIO;
>
> 1951        if (rc)
> 1952                return rc;
>
> 1987                if (rc) {
> 1988                        cifs_small_buf_release(req);
> 1989                        return rc;
> 1990                }

Cleaning that up now. Will post a patch - thx.


-- 
Thanks,

Steve
