From: Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Fri, 10 Jun 2011 17:44:15 +0530
Message-ID: <4DF20A97.8010405@suse.de>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>	<20110609183045.01f6f9fc@tlielax.poochiereds.net>	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>	<20110610073702.061bc014@corrin.poochiereds.net> <BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton@redhat.com>,
	Martijn Uffing <mp3project@sarijopen.student.utwente.nl>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	sean finney <seanius@seanius.net>
To: Connor Hansen <cmdkhh@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 06/10/2011 05:33 PM, Connor Hansen wrote:
> On Fri, Jun 10, 2011 at 4:37 AM, Jeff Layton <jlayton@redhat.com> wrote:
>> On Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
>>  Uffing <mp3project@sarijopen.student.utwente.nl> wrote:
>>
>>>
>>> <snip>
>>>> call in get_dfs_path()
>>>> rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
>>>>
>>>> function header for CIFSTCon
>>>> int  CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>>>>          const char *tree, struct cifs_tcon *tcon,
>>>>          const struct nls_table *nls_codepage)
>>>>
>>>> get_dfs_path() is passing struct cifs_tcon *tcon as NULL
>>>>
>>>> from config:  CONFIG_CIFS_WEAK_PW_HASH=y
>>>>
>>>> in CIFSTCon
>>>>
>>>> #ifdef CONFIG_CIFS_WEAK_PW_HASH
>>>> 3222                 if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
>>>> 3223                     (ses->server->secType == LANMAN))
>>>> 3224                         calc_lanman_hash(tcon->password,
>>>> ses->server->cryptkey,
>>>>
>>>> in calc_lanman_hash tcon is dereferenced(tcon->password) without being
>>>> checked if null
>>>>
>>>> 3225                                          ses->server->sec_mode &
>>>> 3226                                             SECMODE_PW_ENCRYPT ?
>>>> true : false,
>>>> 3227                                          bcc_ptr);
>>>> 3228                 else
>>>> 3229 #endif /* CIFS_WEAK_PW_HASH */
>>>>
>>>> Connor
>>>
>>>
>>> Ave all
>>>
>>> I recompiled  kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_INFO=y) and put
>>> the oops (with the new adresses) through gdb per instruction of Jeff. And
>>> Connor was spot on!
>>>
>>> <qoute oops>
>>> BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
>>> IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
>>> </qoute oops>
>>>
>>> <qoute gdb>
>>> This GDB was configured as "x86_64-linux-gnu".
>>> For bug reporting instructions, please see:
>>> <http://www.gnu.org/software/gdb/bugs/>...
>>> Reading symbols from
>>> /lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
>>> (gdb) list *(CIFSTCon+0xf6)
>>> 0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
>>> 3225                                             ses->server->sec_mode &
>>> 3226                                                SECMODE_PW_ENCRYPT ?
>>> true : false,
>>> 3227                                             bcc_ptr);
>>> 3228                    else
>>> 3229    #endif /* CIFS_WEAK_PW_HASH */
>>> 3230                    rc = SMBNTencrypt(tcon->password,
>>> ses->server->cryptkey,
>>> 3231                                            bcc_ptr);
>>> 3232
>>> 3233                    bcc_ptr += CIFS_AUTH_RESP_SIZE;
>>> 3234                    if (ses->capabilities & CAP_UNICODE) {
>>> (gdb)
>>> </qoute gdb>
>>>
>>
>> (cc'ing Sean F. since I suspect this regression is due to his changes)
>>
>> Thanks for the analysis, Martijn and Connor...
>>
>> What sort of server are you mounting here? It looks like it's using
>> share-level security, so it's either very old or is a samba server
>> configured that way.
>>
>> I suspect that commit c1508ca236 is the culprit. With that, we call
>> into expand_dfs_referral on every mount attempt. Previously we only
>> called into there when we got back  an EREMOTE error and that would
>> have been unlikely on a share-level security connection.
>>
>> I think there are several possible solutions, but since Sean was in
>> here most recently I'd like to have his opinion.
> 
> I don't know enough about cifs but this call in fs/cifs/connect.c
> 
> 2268: rc = CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
> 
> will always result in a null pointer derefence as CIFSTCon uses the
> cifs_tcon struct for passwords without verification

Yes, I too was hovering around this code path today and it doesn't look
correct. Specifically, the call from cifs_dfs_path to CIFSTCon with
cifs_tcon as NULL seems wrong. I tried to do dig history a bit with `git
blame`, but couldn't figure out the commit that introduced this.


-- 
Suresh Jayaraman
