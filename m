From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [smb3] unreachable code and memory leaks
Date: Mon, 18 Jun 2018 08:07:37 -0500
Message-ID: <20180618130737.GA13880@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve,

While doing some static analysis I came across the following piece of code at fs/cifs/smb2pdu.c:2017:

2017                if (n_iov > 2) {
2018                        struct create_context *ccontext =
2019                            (struct create_context *)iov[n_iov-1].iov_base;
2020                        ccontext->Next =
2021                                cpu_to_le32(iov[n_iov-1].iov_len);
2022                }

The code above is unreachable because n_iov is initialized to 2 and, its value is never updated.
I'm not sure how to fix this.

Also, it seems there are multiple places in which memory allocated for *path* is leaking:

1946        else
1947                return -EIO;

1951        if (rc)
1952                return rc;

1987                if (rc) {
1988                        cifs_small_buf_release(req);
1989                        return rc;
1990                }

and more...

Thanks
--
Gustavo
