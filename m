Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BED6C38145
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Sep 2022 20:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiIGUlt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiIGUls (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Sep 2022 16:41:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFEFC1669
        for <linux-cifs@vger.kernel.org>; Wed,  7 Sep 2022 13:41:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6A84A3413D;
        Wed,  7 Sep 2022 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662583303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tPJiVkqwExyw5zj2aGTs/r3UF93hbCHQfa26MQQL9M=;
        b=kd/0w4iaGMitHtmSBC9rVliRBtn5ick6soi1PEakagEXxs1vwMGL4BHPK8BUXsQEyZl56Q
        InZD2qe8kur7Vz3EoLUzpqslZeu3jQ2UkeBmcUUi4qmK1rpwdEw8E1MjZIdU4tgnGkAAEH
        9in/xBIlZcCsA6YO2clrvbbYWQMm5M0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662583303;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tPJiVkqwExyw5zj2aGTs/r3UF93hbCHQfa26MQQL9M=;
        b=qks6G3VNvVAa2rhXW0P8YMcSBXlS0AyZl/xkng/JCvsGf2VkVQoBYh7oMYsfcWM8dnYWA2
        yUSu9GTskLnOeQAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E3A5913486;
        Wed,  7 Sep 2022 20:41:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CoWIKQYCGWPURQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 07 Sep 2022 20:41:42 +0000
Date:   Wed, 7 Sep 2022 17:41:40 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aurelien.aptel@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: perf improvement - use faster macros ALIGN() and
 round_up()
Message-ID: <20220907204140.77ssfeib3zmwvqy2@cyberdelia>
References: <20220906013040.2467-1-ematsumiya@suse.de>
 <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CA+5B0FNBJVFC6-SfVodctu0DkyyZ9DzJM8OJsDBbVb453Mvfsw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/07, Aur=E9lien Aptel wrote:
>Hi,
>
>Changes are good from a readability stand point but like the others
>I'm very skeptical about the perf improvement claims.

Just to be clear, as I re-read the commit message and realize I might have
sounded a tad sensationalist; the "~50% improvement" was from the measure of
the average latency for a single copy operation. As I replied to Tom Talpey=
 in
https://lore.kernel.org/linux-cifs/20220906160508.x4ahjzo3tr34w6k5@cyberdel=
ia/
the actual perceptible gain was only 0.02 to 0.05 seconds on my tests.

Pardon me for any confusion.


Enzo

>On Tue, Sep 6, 2022 at 3:34 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>> But also replace (DIV_ROUND_UP(len, 8) * 8) with ALIGN(len, 8), which,
>> if not optimized by the compiler, has the overhead of a multiplication
>> and a division. Do the same for roundup() by replacing it by round_up()
>> (division-less version, but requires the multiple to be a power of 2,
>> which is always the case for us).
>
>Many of these compile to the same division-less instructions
>especially if any of the values are known at compile time.
>
>> @@ -2305,7 +2305,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, =
struct cifs_tcon *pTcon,
>
>smb1 and computed at compile time
>
>> @@ -3350,8 +3350,7 @@ validate_ntransact(char *buf, char **ppparm, char =
**ppdata,
>
>smb1
>
>> @@ -2833,9 +2833,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
>> @@ -2871,8 +2874,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
>
>connect time
>
>> @@ -1318,7 +1313,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
>> @@ -1442,8 +1437,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>> @@ -1494,7 +1488,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
>> @@ -1546,7 +1540,7 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_dat=
a *sess_data)
>> @@ -1747,7 +1741,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_data=
 *sess_data)
>
>connect time
>
>> @@ -207,7 +207,7 @@ smb2_compound_op(const unsigned int xid, struct cifs=
_tcon *tcon,
>> -               size[0] =3D 1; /* sizeof __u8 See MS-FSCC section 2.4.11=
 */
>> +               size[0] =3D sizeof(u8); /* See MS-FSCC section 2.4.11 */
>> -               size[0] =3D 8; /* sizeof __le64 */
>> +               size[0] =3D sizeof(__le64);
>
>Hot path but no functional change
>
>> @@ -248,7 +248,7 @@ smb2_check_message(char *buf, unsigned int len, stru=
ct TCP_Server_Info *server)
>>                  * Some windows servers (win2016) will pad also the final
>>                  * PDU in a compound to 8 bytes.
>>                  */
>> -               if (((calc_len + 7) & ~7) =3D=3D len)
>> +               if (ALIGN(calc_len, 8) =3D=3D len)
>
>Hot path but should compile to the same thing
>
>> @@ -466,15 +466,14 @@ build_signing_ctxt(struct smb2_signing_capabilitie=
s *pneg_ctxt)
>> @@ -511,8 +510,7 @@ build_netname_ctxt(struct smb2_netname_neg_context *=
pneg_ctxt, char *hostname)
>> @@ -557,18 +555,18 @@ assemble_neg_contexts(struct smb2_negotiate_req *r=
eq,
>> @@ -595,9 +593,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>> @@ -780,7 +776,7 @@ static int smb311_decode_neg_context(struct smb2_neg=
otiate_rsp *rsp,
>
>connect time
>
>> @@ -2413,7 +2409,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsign=
ed int *len)
>> @@ -2487,7 +2483,7 @@ create_sd_buf(umode_t mode, bool set_owner, unsign=
ed int *len)
>
>only relevant if mounted with some acl flags
>
>> @@ -2581,7 +2577,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, int=
 *out_size, int *out_len,
>> -       *out_size =3D roundup(*out_len * sizeof(__le16), 8);
>> +       *out_size =3D round_up(*out_len * sizeof(__le16), 8);
>
>Hot path but from my experiments, round_up() compiles to an *extra*
>instruction. See below.
>
>> @@ -2687,20 +2683,17 @@ int smb311_posix_mkdir(const unsigned int xid, s=
truct inode *inode,
>
>Only relevant on posix mounts.
>
>> @@ -2826,9 +2819,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_=
Server_Info *server,
>> -               copy_size =3D uni_path_len;
>> -               if (copy_size % 8 !=3D 0)
>> -                       copy_size =3D roundup(copy_size, 8);
>> +               copy_size =3D round_up(uni_path_len, 8);
>> @@ -4090,7 +4081,7 @@ smb2_new_read_req(void **buf, unsigned int *total_=
len,
>> -                       *total_len =3D DIV_ROUND_UP(*total_len, 8) * 8;
>> +                       *total_len =3D ALIGN(*total_len, 8);
>
>These 2 are also hot paths, but skeptical about the optimizations.
>
>I've looked at those macros in Compiler Explorer and sure enough they
>compile to the same thing on x86_64.
>Even worse, the optimized versions compile with extra instructions for som=
e:
>
>https://godbolt.org/z/z1xhhW9sj
>
>size_t mod2(size_t num) {
>    return num%2;
>}
>
>size_t is_aligned2(size_t num) {
>    return IS_ALIGNED(num, 2);
>}
>
>mod2:
>        mov     rax, rdi
>        and     eax, 1
>        ret
>
>is_aligned2:
>        mov     rax, rdi
>        not     rax  <=3D=3D=3D extra
>        and     eax, 1
>        ret
>--------------------------
>
>size_t align8(size_t num) {
>    return ALIGN(num, 8);
>}
>
>size_t align_andshift8(size_t num) {
>    return ((num + 7) & ~7);
>}
>
>
>align8:
>        lea     rax, [rdi+7]
>        and     rax, -8
>        ret
>align_andshift8:
>        lea     rax, [rdi+7]
>        and     rax, -8
>        ret
>
>same code
>--------------------------
>
>size_t dru8(size_t num) {
>    return DIV_ROUND_UP(num, 8)*8;
>}
>
>size_t rnup8_a(size_t num) {
>    return round_up(num, 8);
>}
>
>size_t rnup8_b(size_t num) {
>    return roundup(num, 8);
>}
>
>dru8:
>        lea     rax, [rdi+7]
>        and     rax, -8
>        ret
>rnup8_a:
>        lea     rax, [rdi-1]
>        or      rax, 7 <=3D=3D=3D=3D extra
>        add     rax, 1
>        ret
>rnup8_b:
>        lea     rax, [rdi+7]
>        and     rax, -8
>        ret
>
>round_up has an extra instruction
>--------------------------
>
>I suspect the improvements are more likely to be related to caches,
>system load, server load, ...
>You can try to use perf to make a flamegraph and compare.
>
>Cheers,
