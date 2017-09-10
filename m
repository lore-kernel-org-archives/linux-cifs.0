From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] cifs: hide unused functions
Date: Sun, 10 Sep 2017 12:28:17 +0200
Message-ID: <CAMuHMdVjDKE4Gx_GK81SMiZ1ZttWXBVFrMpTbbeH8HFMuU_Ewg@mail.gmail.com>
References: <20170905092440.2172429-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Sachin Prabhu <sprabhu@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905092440.2172429-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Sep 5, 2017 at 11:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The newly added SMB2+ attribute support causes unused function
> warnings when CONFIG_CIFS_XATTR is disabled:
>
> fs/cifs/smb2ops.c:563:1: error: 'smb2_set_ea' defined but not used [-Werror=unused-function]
>  smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
> fs/cifs/smb2ops.c:513:1: error: 'smb2_query_eas' defined but not used [-Werror=unused-function]
>  smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
>
> This adds another #ifdef around the affected functions.
>
> Fixes: 5517554e4313 ("cifs: Add support for writing attributes on SMB2+")
> Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
