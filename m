From: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
 <20110609183045.01f6f9fc@tlielax.poochiereds.net>
 <BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


<snip>
> call in get_dfs_path()
> rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
>
> function header for CIFSTCon
> int  CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>          const char *tree, struct cifs_tcon *tcon,
>          const struct nls_table *nls_codepage)
>
> get_dfs_path() is passing struct cifs_tcon *tcon as NULL
>
> from config:  CONFIG_CIFS_WEAK_PW_HASH=y
>
> in CIFSTCon
>
> #ifdef CONFIG_CIFS_WEAK_PW_HASH
> 3222                 if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
> 3223                     (ses->server->secType == LANMAN))
> 3224                         calc_lanman_hash(tcon->password,
> ses->server->cryptkey,
>
> in calc_lanman_hash tcon is dereferenced(tcon->password) without being
> checked if null
>
> 3225                                          ses->server->sec_mode &
> 3226                                             SECMODE_PW_ENCRYPT ?
> true : false,
> 3227                                          bcc_ptr);
> 3228                 else
> 3229 #endif /* CIFS_WEAK_PW_HASH */
>
> Connor


Ave all

I recompiled  kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_INFO=y) and put 
the oops (with the new adresses) through gdb per instruction of Jeff. And 
Connor was spot on!

<qoute oops>
BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
</qoute oops>

<qoute gdb>
This GDB was configured as "x86_64-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from 
/lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
(gdb) list *(CIFSTCon+0xf6)
0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
3225                                             ses->server->sec_mode &
3226                                                SECMODE_PW_ENCRYPT ? 
true : false,
3227                                             bcc_ptr);
3228                    else
3229    #endif /* CIFS_WEAK_PW_HASH */
3230                    rc = SMBNTencrypt(tcon->password, 
ses->server->cryptkey,
3231                                            bcc_ptr);
3232
3233                    bcc_ptr += CIFS_AUTH_RESP_SIZE;
3234                    if (ses->capabilities & CAP_UNICODE) {
(gdb)
</qoute gdb>

Martijn
