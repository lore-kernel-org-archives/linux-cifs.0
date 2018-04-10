From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Subject: Re: [PATCH] cifs: Use ULL suffix for 64-bit constant
Date: Tue, 10 Apr 2018 11:35:26 +0200
Message-ID: <87zi2bqu8x.fsf@suse.com>
References: <1522933031-25574-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522933031-25574-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:
> On 32-bit (e.g. with m68k-linux-gnu-gcc-4.1):
>
>     fs/cifs/inode.c: In function ‘simple_hashstr’:
>     fs/cifs/inode.c:713: warning: integer constant is too large for ‘long’ type
>
> Fixes: 7ea884c77e5c97f1 ("smb3: Fix root directory when server returns inode number of zero")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

this is already in Steve's for-next, marking as reviewed:

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
