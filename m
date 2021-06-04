Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C71CC4743C
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 20:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04493613D8
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 20:30:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFDUbu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 16:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhFDUbr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Jun 2021 16:31:47 -0400
Received: from s1.jo-so.de (jo-so.de [IPv6:2a03:4000:8:213::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC0BC061766
        for <linux-cifs@vger.kernel.org>; Fri,  4 Jun 2021 13:29:59 -0700 (PDT)
Received: from mail-relay (helo=jo-so.de)
        by s1.jo-so.de with local-bsmtp (Exim 4.92)
        (envelope-from <joerg@jo-so.de>)
        id 1lpGS4-000oTV-7H; Fri, 04 Jun 2021 22:29:56 +0200
Received: from joerg by zenbook.jo-so.de with local (Exim 4.94.2)
        (envelope-from <joerg@jo-so.de>)
        id 1lpGS3-007E5k-H6; Fri, 04 Jun 2021 22:29:55 +0200
Date:   Fri, 4 Jun 2021 22:29:55 +0200
From:   =?utf-8?B?SsO2cmc=?= Sommer <joerg@jo-so.de>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Kernel fails to access file on Fritzbox, but smbget works
Message-ID: <20210604202955.lkf3w7wz2mma2pfo@jo-so.de>
OpenPGP: id=7D2C9A23D1AEA375; url=https://jo-so.de/pgp-key.txt;
 preference=signencrypt
References: <20210604081434.rz63qpcmdhqjjuud@jo-so.de>
 <CAH2r5muc5bLbt7_sGhjR4Q_SAJ8DiTuTTzF_oKPdUp4Gj8f=5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vzppkpzbxmtx5nyi"
Content-Disposition: inline
In-Reply-To: <CAH2r5muc5bLbt7_sGhjR4Q_SAJ8DiTuTTzF_oKPdUp4Gj8f=5w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--vzppkpzbxmtx5nyi
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: Kernel fails to access file on Fritzbox, but smbget works
MIME-Version: 1.0

Steve French schrieb am Fr 04. Jun, 09:51 (-0500):
> I didn't see the error in the trace - might be helpful to try
>=20
> "trace-cmd -e cifs record"  just before you repro the bug
> run "md5sum" in another window (or whatever command you are using that
> gets the error)
> then "trace-cmd show"
>=20
> to see if that shows the error being returned to the app

The case with vers=3Ddefault:

# mount -o vers=3Ddefault /mnt/fritzi

# mount
=E2=80=A6
//fritz.box/fritzi on /mnt/fritzi type cifs (rw,relatime,vers=3D3.1.1,cache=
=3Dstrict,username=3Dpublic,uid=3D1000,forceuid,gid=3D0,noforcegid,addr=3D1=
92.168.178.1,file_mode=3D0644,dir_mode=3D0755,soft,nounix,serverino,mapposi=
x,rsize=3D65536,wsize=3D65536,bsize=3D1048576,echo_interval=3D60,actimeo=3D=
1,user=3Dpublic)

# trace-cmd record -e cifs md5sum /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Back=
up/passwd.kdbx=20
md5sum: /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Backup/passwd.kdbx: Stale file=
 handle
CPU0 data recorded at offset=3D0x7d3000
    4096 bytes in size
CPU1 data recorded at offset=3D0x7d4000
    0 bytes in size
CPU2 data recorded at offset=3D0x7d4000
    4096 bytes in size
CPU3 data recorded at offset=3D0x7d5000
    4096 bytes in size
CPU4 data recorded at offset=3D0x7d6000
    0 bytes in size
CPU5 data recorded at offset=3D0x7d6000
    4096 bytes in size
CPU6 data recorded at offset=3D0x7d7000
    0 bytes in size
CPU7 data recorded at offset=3D0x7d7000
    0 bytes in size

# trace-cmd show
# tracer: nop
#
# entries-in-buffer/entries-written: 0/0   #P:8
#
#                                _-----=3D> irqs-off
#                               / _----=3D> need-resched
#                              | / _---=3D> hardirq/softirq
#                              || / _--=3D> preempt-depth
#                              ||| /     delay
#           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
#              | |         |   ||||      |         |

# trace-cmd report
CPU 1 is empty
CPU 4 is empty
CPU 6 is empty
CPU 7 is empty
cpus=3D8
          md5sum-1716729 [002] 211579.860340: smb3_enter:               fff=
fffffc185dc60: xid=3D529
          md5sum-1716729 [002] 211579.860358: smb3_query_info_compound_ente=
r: xid=3D529 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau
          md5sum-1716729 [002] 211579.860362: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D320
          md5sum-1716729 [002] 211579.860363: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D321
          md5sum-1716729 [002] 211579.860363: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D322
           cifsd-1713396 [002] 211579.869559: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x143 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [000] 211579.869617: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D320
          md5sum-1716729 [000] 211579.869618: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D321
          md5sum-1716729 [000] 211579.869618: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D322
          md5sum-1716729 [000] 211579.869624: smb3_query_info_compound_done=
: xid=3D529 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [000] 211579.869630: smb3_exit_done:           fff=
fffffc185dc60: xid=3D529
          md5sum-1716729 [000] 211579.869634: smb3_enter:               fff=
fffffc185dc60: xid=3D530
          md5sum-1716729 [000] 211579.869646: smb3_query_info_compound_ente=
r: xid=3D530 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public
          md5sum-1716729 [000] 211579.869648: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D323
          md5sum-1716729 [000] 211579.869648: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D324
          md5sum-1716729 [000] 211579.869648: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D325
           cifsd-1713396 [002] 211579.880797: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x146 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [000] 211579.880840: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D323
          md5sum-1716729 [000] 211579.880841: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D324
          md5sum-1716729 [000] 211579.880841: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D325
          md5sum-1716729 [000] 211579.880856: smb3_query_info_compound_done=
: xid=3D530 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [000] 211579.880862: smb3_exit_done:           fff=
fffffc185dc60: xid=3D530
          md5sum-1716729 [000] 211579.880865: smb3_enter:               fff=
fffffc185dc60: xid=3D531
          md5sum-1716729 [000] 211579.880876: smb3_query_info_compound_ente=
r: xid=3D531 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public\J=C3=B6rg-Back=
up
          md5sum-1716729 [000] 211579.880878: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D326
          md5sum-1716729 [000] 211579.880878: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D327
          md5sum-1716729 [000] 211579.880878: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D328
           cifsd-1713396 [002] 211579.894534: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x149 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [000] 211579.894557: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D326
          md5sum-1716729 [000] 211579.894557: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D327
          md5sum-1716729 [000] 211579.894557: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D328
          md5sum-1716729 [000] 211579.894562: smb3_query_info_compound_done=
: xid=3D531 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [000] 211579.894569: smb3_exit_done:           fff=
fffffc185dc60: xid=3D531
          md5sum-1716729 [000] 211579.894573: smb3_enter:               fff=
fffffc185dc60: xid=3D532
          md5sum-1716729 [000] 211579.894585: smb3_query_info_compound_ente=
r: xid=3D532 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public\J=C3=B6rg-Back=
up\passwd.kdbx
          md5sum-1716729 [000] 211579.894586: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D329
          md5sum-1716729 [000] 211579.894586: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D330
          md5sum-1716729 [000] 211579.894587: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D331
           cifsd-1713396 [002] 211579.904001: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x14c credits=3D100 credits_to_add=3D1
          md5sum-1716729 [000] 211579.904045: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D329
          md5sum-1716729 [000] 211579.904045: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D330
          md5sum-1716729 [000] 211579.904045: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D331
          md5sum-1716729 [000] 211579.904060: smb3_query_info_compound_done=
: xid=3D532 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [000] 211579.904073: smb3_exit_done:           fff=
fffffc185dc60: xid=3D532
          md5sum-1716729 [000] 211579.904078: smb3_enter:               fff=
fffffc185d960: xid=3D533
          md5sum-1716729 [000] 211579.904089: smb3_open_enter:      xid=3D5=
33 sid=3D0x5dd tid=3D0x290b cr_opts=3D0x40 des_access=3D0x80000080
          md5sum-1716729 [000] 211579.904090: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D332
           cifsd-1713396 [002] 211579.912964: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x14d credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.912980: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D332
          md5sum-1716729 [005] 211579.912982: smb3_open_done:       xid=3D5=
33 sid=3D0x5dd tid=3D0x290b fid=3D0x4001 cr_opts=3D0x40 des_access=3D0x8000=
0080
          md5sum-1716729 [005] 211579.912989: smb3_close_enter:         xid=
=3D533 sid=3D0x5dd tid=3D0x290b fid=3D0x4001
          md5sum-1716729 [005] 211579.912991: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D333
           cifsd-1713396 [002] 211579.915768: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x14e credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.915798: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D333
          md5sum-1716729 [005] 211579.915800: smb3_close_done:          xid=
=3D533 sid=3D0x5dd tid=3D0x290b fid=3D0x4001
          md5sum-1716729 [005] 211579.915804: smb3_exit_err:            fff=
fffffc185d960: xid=3D533 rc=3D-518
          md5sum-1716729 [005] 211579.915819: smb3_enter:               fff=
fffffc185dc60: xid=3D534
          md5sum-1716729 [005] 211579.915832: smb3_query_info_compound_ente=
r: xid=3D534 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public\J=C3=B6rg-Back=
up\passwd.kdbx
          md5sum-1716729 [005] 211579.915834: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D334
          md5sum-1716729 [005] 211579.915835: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D335
          md5sum-1716729 [005] 211579.915835: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D336
           cifsd-1713396 [002] 211579.925426: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x151 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.925471: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D334
          md5sum-1716729 [005] 211579.925472: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D335
          md5sum-1716729 [005] 211579.925472: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D336
          md5sum-1716729 [005] 211579.925488: smb3_query_info_compound_done=
: xid=3D534 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [005] 211579.925500: smb3_exit_done:           fff=
fffffc185dc60: xid=3D534
          md5sum-1716729 [005] 211579.925505: smb3_enter:               fff=
fffffc185d960: xid=3D535
          md5sum-1716729 [005] 211579.925516: smb3_open_enter:      xid=3D5=
35 sid=3D0x5dd tid=3D0x290b cr_opts=3D0x40 des_access=3D0x80000080
          md5sum-1716729 [005] 211579.925518: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D337
           cifsd-1713396 [002] 211579.934302: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x152 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.934331: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D337
          md5sum-1716729 [005] 211579.934333: smb3_open_done:       xid=3D5=
35 sid=3D0x5dd tid=3D0x290b fid=3D0x4001 cr_opts=3D0x40 des_access=3D0x8000=
0080
          md5sum-1716729 [005] 211579.934341: smb3_close_enter:         xid=
=3D535 sid=3D0x5dd tid=3D0x290b fid=3D0x4001
          md5sum-1716729 [005] 211579.934343: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D338
           cifsd-1713396 [002] 211579.937048: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x153 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.937063: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D338
          md5sum-1716729 [005] 211579.937064: smb3_close_done:          xid=
=3D535 sid=3D0x5dd tid=3D0x290b fid=3D0x4001
          md5sum-1716729 [005] 211579.937067: smb3_exit_err:            fff=
fffffc185d960: xid=3D535 rc=3D-518
          md5sum-1716729 [005] 211579.937078: smb3_enter:               fff=
fffffc185dc60: xid=3D536
          md5sum-1716729 [005] 211579.937088: smb3_query_info_compound_ente=
r: xid=3D536 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau
          md5sum-1716729 [005] 211579.937089: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D339
          md5sum-1716729 [005] 211579.937090: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D340
          md5sum-1716729 [005] 211579.937090: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D341
           cifsd-1713396 [002] 211579.945384: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x156 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.945391: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D339
          md5sum-1716729 [005] 211579.945391: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D340
          md5sum-1716729 [005] 211579.945391: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D341
          md5sum-1716729 [005] 211579.945393: smb3_query_info_compound_done=
: xid=3D536 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [005] 211579.945396: smb3_exit_done:           fff=
fffffc185dc60: xid=3D536
          md5sum-1716729 [005] 211579.945398: smb3_enter:               fff=
fffffc185dc60: xid=3D537
          md5sum-1716729 [005] 211579.945403: smb3_query_info_compound_ente=
r: xid=3D537 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public
          md5sum-1716729 [005] 211579.945404: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D342
          md5sum-1716729 [005] 211579.945404: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D343
          md5sum-1716729 [005] 211579.945404: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D344
           cifsd-1713396 [003] 211579.953444: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x159 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.953468: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D342
          md5sum-1716729 [005] 211579.953468: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D343
          md5sum-1716729 [005] 211579.953469: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D344
          md5sum-1716729 [005] 211579.953474: smb3_query_info_compound_done=
: xid=3D537 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [005] 211579.953483: smb3_exit_done:           fff=
fffffc185dc60: xid=3D537
          md5sum-1716729 [005] 211579.953488: smb3_enter:               fff=
fffffc185dc60: xid=3D538
          md5sum-1716729 [005] 211579.953501: smb3_query_info_compound_ente=
r: xid=3D538 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public\J=C3=B6rg-Back=
up
          md5sum-1716729 [005] 211579.953504: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D345
          md5sum-1716729 [005] 211579.953504: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D346
          md5sum-1716729 [005] 211579.953504: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D347
           cifsd-1713396 [003] 211579.962898: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x15c credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.962911: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D345
          md5sum-1716729 [005] 211579.962912: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D346
          md5sum-1716729 [005] 211579.962912: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D347
          md5sum-1716729 [005] 211579.962918: smb3_query_info_compound_done=
: xid=3D538 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [005] 211579.962925: smb3_exit_done:           fff=
fffffc185dc60: xid=3D538
          md5sum-1716729 [005] 211579.962929: smb3_enter:               fff=
fffffc185dc60: xid=3D539
          md5sum-1716729 [005] 211579.962944: smb3_query_info_compound_ente=
r: xid=3D539 sid=3D0x290b tid=3D0x5dd path=3D\WD_blau\Public\J=C3=B6rg-Back=
up\passwd.kdbx
          md5sum-1716729 [005] 211579.962946: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D348
          md5sum-1716729 [005] 211579.962946: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D349
          md5sum-1716729 [005] 211579.962946: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D350
           cifsd-1713396 [003] 211579.971979: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x15f credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.972024: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D348
          md5sum-1716729 [005] 211579.972035: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D16 mid=3D349
          md5sum-1716729 [005] 211579.972035: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D350
          md5sum-1716729 [005] 211579.972039: smb3_query_info_compound_done=
: xid=3D539 sid=3D0x290b tid=3D0x5dd
          md5sum-1716729 [005] 211579.972051: smb3_exit_done:           fff=
fffffc185dc60: xid=3D539
          md5sum-1716729 [005] 211579.972057: smb3_enter:               fff=
fffffc185d960: xid=3D540
          md5sum-1716729 [005] 211579.972066: smb3_open_enter:      xid=3D5=
40 sid=3D0x5dd tid=3D0x290b cr_opts=3D0x40 des_access=3D0x80000080
          md5sum-1716729 [005] 211579.972067: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D351
           cifsd-1713396 [003] 211579.980660: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x160 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.980703: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D5 mid=3D351
          md5sum-1716729 [005] 211579.980715: smb3_open_done:       xid=3D5=
40 sid=3D0x5dd tid=3D0x290b fid=3D0x4001 cr_opts=3D0x40 des_access=3D0x8000=
0080
          md5sum-1716729 [005] 211579.980723: smb3_close_enter:         xid=
=3D540 sid=3D0x5dd tid=3D0x290b fid=3D0x4001
          md5sum-1716729 [005] 211579.980725: smb3_cmd_enter:           sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D352
           cifsd-1713396 [003] 211579.983518: smb3_add_credits:     server=
=3Dffff9ca1ea3a3b50 current_mid=3D0x161 credits=3D100 credits_to_add=3D1
          md5sum-1716729 [005] 211579.983561: smb3_cmd_done:            sid=
=3D0x5dd tid=3D0x290b cmd=3D6 mid=3D352
          md5sum-1716729 [005] 211579.983573: smb3_close_done:          xid=
=3D540 sid=3D0x5dd tid=3D0x290b fid=3D0x4001
          md5sum-1716729 [005] 211579.983577: smb3_exit_err:            fff=
fffffc185d960: xid=3D540 rc=3D-518

# umount /mnt/fritzi

And this is for vers=3D1.0

# mount -o vers=3D1.0 /mnt/fritzi
# mount |grep fritzi
//fritz.box/fritzi on /mnt/fritzi type cifs (rw,relatime,vers=3D1.0,cache=
=3Dstrict,username=3Dpublic,uid=3D1000,forceuid,gid=3D0,noforcegid,addr=3D1=
92.168.178.1,file_mode=3D0644,dir_mode=3D0755,soft,nounix,serverino,mapposi=
x,rsize=3D61440,wsize=3D65536,bsize=3D1048576,echo_interval=3D60,actimeo=3D=
1,user=3Dpublic)
# trace-cmd record -e cifs md5sum /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Back=
up/passwd.kdbx
md5sum: /mnt/fritzi/WD_blau/Public/J=C3=B6rg-Backup/passwd.kdbx: Input/outp=
ut error
CPU0 data recorded at offset=3D0x7d3000
    0 bytes in size
CPU1 data recorded at offset=3D0x7d3000
    4096 bytes in size
CPU2 data recorded at offset=3D0x7d4000
    0 bytes in size
CPU3 data recorded at offset=3D0x7d4000
    0 bytes in size
CPU4 data recorded at offset=3D0x7d4000
    4096 bytes in size
CPU5 data recorded at offset=3D0x7d5000
    0 bytes in size
CPU6 data recorded at offset=3D0x7d5000
    4096 bytes in size
CPU7 data recorded at offset=3D0x7d6000
    0 bytes in size

# trace-cmd show
# tracer: nop
#
# entries-in-buffer/entries-written: 0/0   #P:8
#
#                                _-----=3D> irqs-off
#                               / _----=3D> need-resched
#                              | / _---=3D> hardirq/softirq
#                              || / _--=3D> preempt-depth
#                              ||| /     delay
#           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
#              | |         |   ||||      |         |

# trace-cmd report
CPU 0 is empty
CPU 2 is empty
CPU 3 is empty
CPU 5 is empty
CPU 7 is empty
cpus=3D8
          md5sum-1720537 [004] 212113.150901: smb3_enter:               fff=
fffffc185d3d8: xid=3D550
          md5sum-1720537 [004] 212113.162157: smb3_exit_done:           fff=
fffffc185d3d8: xid=3D550
          md5sum-1720537 [004] 212113.162163: smb3_enter:               fff=
fffffc185d3d8: xid=3D551
          md5sum-1720537 [004] 212113.174790: smb3_exit_done:           fff=
fffffc185d3d8: xid=3D551
          md5sum-1720537 [004] 212113.174796: smb3_enter:               fff=
fffffc185d3d8: xid=3D552
          md5sum-1720537 [004] 212113.188124: smb3_exit_done:           fff=
fffffc185d3d8: xid=3D552
          md5sum-1720537 [004] 212113.188130: smb3_enter:               fff=
fffffc185d3d8: xid=3D553
          md5sum-1720537 [004] 212113.202783: smb3_exit_done:           fff=
fffffc185d3d8: xid=3D553
          md5sum-1720537 [004] 212113.202790: smb3_enter:               fff=
fffffc185d960: xid=3D554
          md5sum-1720537 [006] 212113.212839: smb3_exit_done:           fff=
fffffc185d960: xid=3D554
          md5sum-1720537 [001] 212113.793956: smb3_enter:               fff=
fffffc185d970: xid=3D555

# umount /mnt/fritzi

> On Fri, Jun 4, 2021 at 3:31 AM J=C3=B6rg Sommer <joerg@jo-so.de> wrote:
> >
> > Hi,
> >
> > I have a nasty problem. I use a cable router named Fritzbox (6490 Cable,
> > FritzOS 7.27) as server, but the kernel (5.10.0-7-amd64, Debian-unstabl=
e)
> > has problems to access the files on the share.
> >
> > This is a network capture using smbget to fetch a file:
> >
> > ```
> > 107.477947156   client  server  Negotiate Protocol Request
> > SMB2 (Server Message Block Protocol version 2)
> >     SMB2 Header
> >         ProtocolId: 0xfe534d42
> >         Header Length: 64
> >         Credit Charge: 0
> >         Channel Sequence: 0
> >         Reserved: 0000
> >         Command: Negotiate Protocol (0)
> >         Credits requested: 31
> >         Flags: 0x00000000
> >         Chain Offset: 0x00000000
> >         Message ID: 0
> >         Process Id: 0x00000000
> >         Tree Id: 0x00000000
> >         Session Id: 0x0000000000000000
> >         Signature: 00000000000000000000000000000000
> >         [Response in: 2216]
> >     Negotiate Protocol Request (0x00)
> >         [Preauth Hash: 09d3a214a8f08e401aa10f5c46c79bfb4b4cbfea0c181589=
954df4c325e4b054085bfe90=E2=80=A6]
> >         StructureSize: 0x0024
> >         Dialect count: 8
> >         Security mode: 0x01, Signing enabled
> >         Reserved: 0000
> >         Capabilities: 0x0000007f, DFS, LEASING, LARGE MTU, MULTI CHANNE=
L, PERSISTENT HANDLES, DIRECTORY LEASING, ENCRYPTION
> >         Client Guid: e612920f-05ad-41f1-b34b-5e7650d1be90
> >         NegotiateContextOffset: 0x00000078
> >         NegotiateContextCount: 3
> >         Reserved: 0000
> >         Dialect: SMB 2.0.2 (0x0202)
> >         Dialect: SMB 2.1 (0x0210)
> >         Dialect: Unknown (0x0222)
> >         Dialect: Unknown (0x0224)
> >         Dialect: SMB 3.0 (0x0300)
> >         Dialect: SMB 3.0.2 (0x0302)
> >         Dialect: SMB 3.1.0 (deprecated; should be 3.1.1) (0x0310)
> >         Dialect: SMB 3.1.1 (0x0311)
> >         Negotiate Context: SMB2_PREAUTH_INTEGRITY_CAPABILITIES
> >         Negotiate Context: SMB2_ENCRYPTION_CAPABILITIES
> >         Negotiate Context: SMB2_NETNAME_NEGOTIATE_CONTEXT_ID
> > 107.481115263   server  client  Negotiate Protocol Response
> > SMB2 (Server Message Block Protocol version 2)
> >     SMB2 Header
> >         ProtocolId: 0xfe534d42
> >         Header Length: 64
> >         Credit Charge: 0
> >         NT Status: STATUS_SUCCESS (0x00000000)
> >         Command: Negotiate Protocol (0)
> >         Credits granted: 1
> >         Flags: 0x00000001, Response
> >         Chain Offset: 0x00000000
> >         Message ID: 0
> >         Process Id: 0x00000000
> >         Tree Id: 0x00000000
> >         Session Id: 0x0000000000000000
> >         Signature: 00000000000000000000000000000000
> >         [Response to: 2214]
> >         [Time from request: 0.003168107 seconds]
> >     Negotiate Protocol Response (0x00)
> >         [Preauth Hash: 25b9c1efb89f4aa0d8fa9bddd3a8cf7f72298b0019718780=
1a11006578ecbcdf23bcdb9f=E2=80=A6]
> >         StructureSize: 0x0041
> >         Security mode: 0x01, Signing enabled
> >         Dialect: SMB 3.1.1 (0x0311)
> >         NegotiateContextCount: 2
> >         Server Guid: 7369c667-ff51-ec4a-29cd-baabf2fbe346
> >         Capabilities: 0x00000000
> >         Max Transaction Size: 65696
> >         Max Read Size: 65564
> >         Max Write Size: 65584
> >         Current Time: Jun  4, 2021 09:22:04.866600000 CEST
> >         Boot Time: Sep 14, 2000 20:34:26.039600000 CEST
> >         Blob Offset: 0x00000080
> >         Blob Length: 74
> >         Security Blob: 604806062b0601050502a03e303ca00e300c060a2b060104=
01823702020aa32a3028a026=E2=80=A6
> >         NegotiateContextOffset: 0x000000d0
> >         Negotiate Context: SMB2_PREAUTH_INTEGRITY_CAPABILITIES
> >         Negotiate Context: SMB2_ENCRYPTION_CAPABILITIES
> > 107.482745267   client  server  Session Setup Request, NTLMSSP_NEGOTIATE
> > 107.486012547   server  client  Session Setup Response, Error: STATUS_M=
ORE_PROCESSING_REQUIRED, NTLMSSP_CHALLENGE
> > 107.486294745   client  server  Session Setup Request, NTLMSSP_AUTH, Us=
er: WORKGROUP\public
> > 107.495302076   server  client  Session Setup Response
> > 107.495509240   client  server  Tree Connect Request Tree: \\server\fri=
tzi
> > 107.498547296   server  client  Tree Connect Response
> > 107.498736847   client  server  Create Request File:
> > 107.503489606   server  client  Create Response File:
> > 107.503663348   client  server  GetInfo Request FS_INFO/FileFsAttribute=
Information File:
> > 107.506197658   server  client  GetInfo Response
> > 107.506366587   client  server  Close Request File:
> > 107.509582634   server  client  Close Response
> > 107.509816409   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx
> > 107.517840241   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx
> > 107.518034187   client  server  GetInfo Request FILE_INFO/SMB2_FILE_ALL=
_INFO File: WD_blau\Public\J=C3=B6rg-Backup\passwd.kdbx
> > 107.521217971   server  client  GetInfo Response
> > 107.521347702   client  server  Read Request Len:64000 Off:0 File: WD_b=
lau\Public\J=C3=B6rg-Backup\passwd.kdbx
> > 107.823992939   server  client  Read Response
> > =E2=80=A6
> > 108.280977571   client  server  Read Request Len:64000 Off:3840000 File=
: WD_blau\Public\J=C3=B6rg-Backup\passwd.kdbx
> > 108.284075230   server  client  Read Response
> > 108.284259643   client  server  Read Request Len:48413 Off:3855587 File=
: WD_blau\Public\J=C3=B6rg-Backup\passwd.kdbx
> > 108.286540047   server  client  Read Response, Error: STATUS_END_OF_FILE
> > 108.286742343   client  server  Close Request File: WD_blau\Public\J=C3=
=B6rg-Backup\passwd.kdbx
> > 108.289520300   server  client  Close Response
> > ```
> >
> > This is a network capture using mount vers=3Ddefault to fetch the same =
file.
> > Accessing the file with md5sum gives `Stale file handle`
> >
> > ```
> > 159.745293999   client  server  Negotiate Protocol Request
> > SMB2 (Server Message Block Protocol version 2)
> >     SMB2 Header
> >         ProtocolId: 0xfe534d42
> >         Header Length: 64
> >         Credit Charge: 0
> >         Channel Sequence: 0
> >         Reserved: 0000
> >         Command: Negotiate Protocol (0)
> >         Credits requested: 10
> >         Flags: 0x00000000
> >         Chain Offset: 0x00000000
> >         Message ID: 0
> >         Process Id: 0x0000d504
> >         Tree Id: 0x00000000
> >         Session Id: 0x0000000000000000
> >         Signature: 00000000000000000000000000000000
> >         [Response in: 3341]
> >     Negotiate Protocol Request (0x00)
> >         [Preauth Hash: 637eee42d4a0314f3fb6050d55a25a0b04070a334135bd5e=
ae14c88d2e0acfae84c8312f=E2=80=A6]
> >         StructureSize: 0x0024
> >         Dialect count: 4
> >         Security mode: 0x01, Signing enabled
> >         Reserved: 0000
> >         Capabilities: 0x00000077, DFS, LEASING, LARGE MTU, PERSISTENT H=
ANDLES, DIRECTORY LEASING, ENCRYPTION
> >         Client Guid: 10b7aee0-c6dc-5341-aef1-6c8c1d5bef4e
> >         NegotiateContextOffset: 0x00000070
> >         NegotiateContextCount: 4
> >         Reserved: 0000
> >         Dialect: SMB 2.1 (0x0210)
> >         Dialect: SMB 3.0 (0x0300)
> >         Dialect: SMB 3.0.2 (0x0302)
> >         Dialect: SMB 3.1.1 (0x0311)
> >         Negotiate Context: SMB2_PREAUTH_INTEGRITY_CAPABILITIES
> >         Negotiate Context: SMB2_ENCRYPTION_CAPABILITIES
> >         Negotiate Context: SMB2_NETNAME_NEGOTIATE_CONTEXT_ID
> >         Negotiate Context: SMB2_POSIX_EXTENSIONS_CAPABILITIES
> > 159.747346324   server  client  Negotiate Protocol Response
> > SMB2 (Server Message Block Protocol version 2)
> >     SMB2 Header
> >         ProtocolId: 0xfe534d42
> >         Header Length: 64
> >         Credit Charge: 0
> >         NT Status: STATUS_SUCCESS (0x00000000)
> >         Command: Negotiate Protocol (0)
> >         Credits granted: 1
> >         Flags: 0x00000001, Response
> >         Chain Offset: 0x00000000
> >         Message ID: 0
> >         Process Id: 0x0000d504
> >         Tree Id: 0x00000000
> >         Session Id: 0x0000000000000000
> >         Signature: 00000000000000000000000000000000
> >         [Response to: 3339]
> >         [Time from request: 0.002052325 seconds]
> >     Negotiate Protocol Response (0x00)
> >         [Preauth Hash: 22993b274035b9b6a3cadf7a6c19b9b757df11aff9a45d7c=
9c70acfc3e830ef0b64034d6=E2=80=A6]
> >         StructureSize: 0x0041
> >         Security mode: 0x01, Signing enabled
> >         Dialect: SMB 3.1.1 (0x0311)
> >         NegotiateContextCount: 2
> >         Server Guid: 7369c667-ff51-ec4a-29cd-baabf2fbe346
> >         Capabilities: 0x00000000
> >         Max Transaction Size: 65696
> >         Max Read Size: 65564
> >         Max Write Size: 65584
> >         Current Time: Jun  4, 2021 09:22:57.133600000 CEST
> >         Boot Time: Sep 14, 2000 20:34:26.039600000 CEST
> >         Blob Offset: 0x00000080
> >         Blob Length: 74
> >         Security Blob: 604806062b0601050502a03e303ca00e300c060a2b060104=
01823702020aa32a3028a026=E2=80=A6
> >         NegotiateContextOffset: 0x000000d0
> >         Negotiate Context: SMB2_PREAUTH_INTEGRITY_CAPABILITIES
> >         Negotiate Context: SMB2_ENCRYPTION_CAPABILITIES
> > 159.747489696   client  server  Session Setup Request, NTLMSSP_NEGOTIATE
> > 159.749757908   server  client  Session Setup Response, Error: STATUS_M=
ORE_PROCESSING_REQUIRED, NTLMSSP_CHALLENGE
> > 159.749963978   client  server  Session Setup Request, NTLMSSP_AUTH, Us=
er: \public
> > 159.755666410   server  client  Session Setup Response
> > 159.755822268   client  server  Tree Connect Request Tree: \\server\IPC$
> > 159.757998425   server  client  Tree Connect Response
> > 159.758149227   client  server  Tree Connect Request Tree: \\server\fri=
tzi
> > 159.761217776   server  client  Tree Connect Response
> > 159.761390846   client  server  Create Request File:
> > 159.766487167   server  client  Create Response File:
> > 159.766633459   client  server  Ioctl Request FSCTL_QUERY_NETWORK_INTER=
FACE_INFO
> > 159.768736951   server  client  Ioctl Response, Error: STATUS_NOT_SUPPO=
RTED
> > 159.768892535   client  server  GetInfo Request FS_INFO/FileFsAttribute=
Information File:
> > 159.772155096   server  client  GetInfo Response
> > 159.772308033   client  server  GetInfo Request FS_INFO/FileFsDeviceInf=
ormation File:
> > 159.774874452   server  client  GetInfo Response
> > 159.775022603   client  server  GetInfo Request FS_INFO/FileFsVolumeInf=
ormation File:
> > 159.778130405   server  client  GetInfo Response
> > 159.778279828   client  server  GetInfo Request FS_INFO/FileFsSectorSiz=
eInformation File:
> > 159.780849883   server  client  GetInfo Response, Error: STATUS_NOT_SUP=
PORTED
> > 159.781003009   client  server  Close Request File:
> > 159.783777662   server  client  Close Response
> > 159.783938472   client  server  Ioctl Request FSCTL_DFS_GET_REFERRALS, =
File: \server\fritzi
> > 159.786039870   server  client  Ioctl Response, Error: STATUS_NOT_FOUND
> > 159.786193956   client  server  Create Request File:
> > 159.790835187   server  client  Create Response File:
> > 159.790981359   client  server  Close Request File:
> > 159.793822253   server  client  Close Response
> > 159.793952080   client  server  Create Request File:
> > 159.798685685   server  client  Create Response File:
> > 159.798838348   client  server  Close Request File:
> > 159.801688226   server  client  Close Response
> > 159.801945547   client  server  Create Request File: ;GetInfo Request F=
ILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 159.807449380   server  client  Create Response File: ;GetInfo Response=
;Close Response
> > 162.884160365   client  server  Create Request File: WD_blau;GetInfo Re=
quest FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 162.892931850   server  client  Create Response File: ;GetInfo Response=
;Close Response
> > 162.893066730   client  server  Create Request File: WD_blau\Public;Get=
Info Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 162.901135678   server  client  Create Response File: ;GetInfo Response=
;Close Response
> > 162.901307878   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 162.910088237   server  client  Create Response File: ;GetInfo Response=
;Close Response
> > 162.910199171   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Cl=
ose Request
> > 162.919726743   server  client  Create Response File: ;GetInfo Response=
;Close Response
> > 162.919841841   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx
> > 162.928605146   server  client  Create Response File:
> > 162.928699866   client  server  Close Request File:
> > 162.931355762   server  client  Close Response
> > 162.931456051   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Cl=
ose Request
> > 162.941435848   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup;GetInfo Response;Close Response
> > 162.941552518   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx
> > 162.950640950   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup
> > 162.950727794   client  server  Close Request File: WD_blau\Public\J=C3=
=B6rg-Backup
> > 162.953512696   server  client  Close Response
> > 162.953612392   client  server  Create Request File: WD_blau;GetInfo Re=
quest FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 162.960265634   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Response;Close Response
> > 162.960363152   client  server  Create Request File: WD_blau\Public;Get=
Info Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 162.968120926   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Response;Close Response
> > 162.968234195   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 162.977020433   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Response;Close Response
> > 162.977123224   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Request FILE_INFO/SMB2_FILE_ALL_INFO;Cl=
ose Request
> > 162.986415829   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx;GetInfo Response;Close Response
> > 162.986554470   client  server  Create Request File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx
> > 162.995019319   server  client  Create Response File: WD_blau\Public\J=
=C3=B6rg-Backup\passwd.kdbx
> > 162.995101551   client  server  Close Request File: WD_blau\Public\J=C3=
=B6rg-Backup\passwd.kdbx
> > 162.997887122   server  client  Close Response
> > 169.505713730   client  server  Create Request File: ;GetInfo Request F=
ILE_INFO/SMB2_FILE_ALL_INFO;Close Request
> > 169.512323741   server  client  Create Response File: WD_blau\Public;Ge=
tInfo Response;Close Response
> > 169.512860789   client  server  Tree Disconnect Request
> > 169.515188660   server  client  Tree Disconnect Response
> > 169.515259125   client  server  Session Logoff Request
> > 169.517551272   server  client  Session Logoff Response
> > ```
> >
> > And this is an access of the file with mount vers=3D1.0. md5sum reports
> > `Input/output error`
> >
> > ```
> > 181.652435091   client  server  Negotiate Protocol Request
> > SMB (Server Message Block Protocol)
> >     SMB Header
> >         Server Component: SMB
> >         [Response in: 3642]
> >         SMB Command: Negotiate Protocol (0x72)
> >         NT Status: STATUS_SUCCESS (0x00000000)
> >         Flags: 0x00
> >         Flags2: 0xc801, Unicode Strings, Error Code Type, Extended Secu=
rity Negotiation, Long Names Allowed
> >         Process ID High: 23
> >         Signature: 0000000000000000
> >         Reserved: 0000
> >         Tree ID: 0
> >         Process ID: 54746
> >         User ID: 0
> >         Multiplex ID: 1
> >     Negotiate Protocol Request (0x72)
> >         Word Count (WCT): 0
> >         Byte Count (BCC): 43
> >         Requested Dialects
> >             Dialect: LM1.2X002
> >             Dialect: LANMAN2.1
> >             Dialect: NT LM 0.12
> >             Dialect: POSIX 2
> > 181.655826070   server  client  Negotiate Protocol Response
> > SMB (Server Message Block Protocol)
> >     SMB Header
> >         Server Component: SMB
> >         [Response to: 3640]
> >         [Time from request: 0.003390979 seconds]
> >         SMB Command: Negotiate Protocol (0x72)
> >         NT Status: STATUS_SUCCESS (0x00000000)
> >         Flags: 0x88, Request/Response, Case Sensitivity
> >         Flags2: 0xc801, Unicode Strings, Error Code Type, Extended Secu=
rity Negotiation, Long Names Allowed
> >         Process ID High: 23
> >         Signature: 0000000000000000
> >         Reserved: 0000
> >         Tree ID: 0
> >         Process ID: 54746
> >         User ID: 0
> >         Multiplex ID: 1
> >     Negotiate Protocol Response (0x72)
> >         Word Count (WCT): 17
> >         Selected Index: 2: NT LM 0.12
> >         Security Mode: 0x07, Mode, Password, Signatures
> >         Max Mpx Count: 10
> >         Max VCs: 1
> >         Max Buffer Size: 65536
> >         Max Raw Buffer: 65536
> >         Session Key: 0x00000000
> >         Capabilities: 0x8000e05c, Unicode, Large Files, NT SMBs, NT Sta=
tus Codes, Infolevel Passthru, Large ReadX, Large WriteX, Extended Security
> >         System Time: Jun  4, 2021 09:23:19.039600000 CEST
> >         Server Time Zone: -120 min from UTC
> >         Challenge Length: 0
> >         Byte Count (BCC): 90
> >         Server GUID: 67c66973-51ff-4aec-29cd-baabf2fbe346
> >         Security Blob: 604806062b0601050502a03e303ca00e300c060a2b060104=
01823702020aa32a3028a026=E2=80=A6
> > 181.655974252   client  server  Session Setup AndX Request, NTLMSSP_NEG=
OTIATE
> > 181.658209133   server  client  Session Setup AndX Response, NTLMSSP_CH=
ALLENGE, Error: STATUS_MORE_PROCESSING_REQUIRED
> > 181.658295009   client  server  Session Setup AndX Request, NTLMSSP_AUT=
H, User: \public
> > 181.662947503   server  client  Session Setup AndX Response
> > 181.663081108   client  server  Tree Connect AndX Request, Path: \\serv=
er\IPC$
> > 181.665337749   server  client  Tree Connect AndX Response
> > 181.665505345   client  server  Tree Connect AndX Request, Path: \\serv=
er\fritzi
> > 181.669439351   server  client  Tree Connect AndX Response
> > 181.669585289   client  server  Trans2 Request, QUERY_FS_INFO, Query FS=
 Device Info
> > 181.672183252   server  client  Trans2 Response, QUERY_FS_INFO
> > 181.672266260   client  server  Trans2 Request, QUERY_FS_INFO, Query FS=
 Attribute Info
> > 181.674872915   server  client  Trans2 Response, QUERY_FS_INFO
> > 181.674965933   client  server  Trans2 Request, GET_DFS_REFERRAL, File:=
 \server\fritzi
> > 181.677692923   server  client  Trans2 Response, GET_DFS_REFERRAL, Erro=
r: STATUS_NOT_SUPPORTED
> > 181.677809275   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path:
> > 181.681715358   server  client  Trans2 Response, QUERY_PATH_INFO
> > 181.681847587   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path:
> > 181.686809347   server  client  Trans2 Response, QUERY_PATH_INFO
> > 181.687021639   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path:
> > 181.691405260   server  client  Trans2 Response, QUERY_PATH_INFO
> > 181.691552739   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File Internal Info, Path:
> > 181.695055860   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.873928911   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path: \WD_blau
> > 182.880656088   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.880792332   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File Internal Info, Path: \WD_blau
> > 182.886816299   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.887061740   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path: \WD_blau\Public
> > 182.892873238   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.893011485   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File Internal Info, Path: \WD_blau\Public
> > 182.898630411   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.898728260   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path: \WD_blau\Public\J=C3=B6rg-Backup
> > 182.905397538   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.905490065   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File Internal Info, Path: \WD_blau\Public\J=C3=B6rg-Backup
> > 182.911806490   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.911904941   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path: \WD_blau\Public\J=C3=B6rg-Backup\passwd.kdbx
> > 182.919436779   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.919514901   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File Internal Info, Path: \WD_blau\Public\J=C3=B6rg-Backup\passwd.kdbx
> > 182.926356968   server  client  Trans2 Response, QUERY_PATH_INFO
> > 182.926478308   client  server  NT Create AndX Request, FID: 0x4001, Pa=
th: \WD_blau\Public\J=EF=BF=BDrg-Backup\passwd.kdbx
> > 182.935217463   server  client  NT Create AndX Response, FID: 0x4001
> > 182.935431010   client  server  Read AndX Request, FID: 0x4001, 32768 b=
ytes at offset 0
> > 182.947742379   server  client  Read AndX Response, FID: 0x4001, 32768 =
bytes
> > =E2=80=A6
> > 183.462757494   client  server  Read AndX Request, FID: 0x4001, 32768 b=
ytes at offset 3833856
> > 183.465864287   server  client  Read AndX Response, FID: 0x4001, 21731 =
bytes
> > 183.466023126   client  server  Read AndX Request, FID: 0x4001, 8192 by=
tes at offset 3855587
> > 183.468370770   server  client  Read AndX Response, FID: 0x4001, Error:=
 STATUS_END_OF_FILE
> > 183.468490608   client  server  Read AndX Request, FID: 0x4001, 8192 by=
tes at offset 3855587
> > 183.470547535   server  client  Read AndX Response, FID: 0x4001, Error:=
 STATUS_END_OF_FILE
> > 183.470775894   client  server  Close Request, FID: 0x4001
> > 183.472856467   server  client  Close Response, FID: 0x4001
> > 187.299929279   client  server  Trans2 Request, QUERY_PATH_INFO, Query =
File All Info, Path:
> > 187.304405796   server  client  Trans2 Response, QUERY_PATH_INFO
> > 187.304940291   client  server  Tree Disconnect Request
> > 187.307143775   server  client  Tree Disconnect Response
> > 187.307301303   client  server  Logoff AndX Request
> > 187.309632364   server  client  Logoff AndX Response
> > ```
> >
> > Can anyone help?
> >
> > Kind regards, J=C3=B6rg
> >
> > --
> > Ich halte ihn zwar f=C3=BCr einen Schurken und das was er sagt f=C3=BCr
> > falsch =E2=80=93 aber ich bin bereit mein Leben daf=C3=BCr einzusetzen,=
 da=C3=9F
> > er seine Meinung sagen kann.            (Voltaire)
>=20
>=20
>=20
> --=20
> Thanks,
>=20
> Steve
>=20

--=20
Freiheit hei=C3=9Ft, die Wahl zu haben, wessen Sklave man ist.

--vzppkpzbxmtx5nyi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJMEAREIADsWIQS1pYxd0T/67YejVyF9LJoj0a6jdQUCYLqNQR0YaHR0cHM6Ly9q
by1zby5kZS9wZ3Ata2V5LnR4dAAKCRB9LJoj0a6jdcPXAP9HEt2Z31DnGefUb6Z0
s1wt2gC8tUCncW6iQB7raN0i/QEAn9N6NeTgZNOaD4C3tRl8KPSlZyT7rbuVJ6Nc
Ymiq7Zc=
=dWOX
-----END PGP SIGNATURE-----

--vzppkpzbxmtx5nyi--
