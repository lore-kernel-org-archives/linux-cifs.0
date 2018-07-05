From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Subject: Re: [PATCH] cifs: Fix slab-out-of-bounds in send_set_info() on SMB2 ACE setting
Date: Thu, 05 Jul 2018 18:05:27 +0200
Message-ID: <87a7r57jnc.fsf@suse.com>
References: <af471807b329692a387ff26e62e1bbca01e1684f.1530783326.git.sbrivio@redhat.com> <87d0w17nu3.fsf@suse.com> <20180705165858.7679fc44@epycfail>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Jianhong Yin <jiyin@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        stable@vger.kernel.org
To: Stefano Brivio <sbrivio@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180705165858.7679fc44@epycfail>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> writes:
> I think it does: for SMB2_SET_INFO we'll allocate with cifs_buf_get(),
> which does:
>
> 	ret_buf = mempool_alloc(cifs_req_poolp, GFP_NOFS);
>
> and release with cifs_buf_release():
>
> 	mempool_free(buf_to_free, cifs_req_poolp);
>
> am I missing something?

I was just reading the diff and assumed it was all in the same function
nevermind, you're right.

Fix is correct but I don't like having packet specific code in the init
function.

We could also raise the small buf mempool slab size to take into account
the SETINFO with ACL so that it fits in a small buf.

It would be interesting to know the max size of a SETINFO for ACL for
that.

Meanwhile this is good enough as far as I'm concerned (if anyone has
other ideas feel free to comment).

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
