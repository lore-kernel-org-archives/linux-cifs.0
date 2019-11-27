Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A740C432C0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 12:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12FF020722
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 12:20:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=inogs-it.20150623.gappssmtp.com header.i=@inogs-it.20150623.gappssmtp.com header.b="TJDAWQdQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK0MUf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Nov 2019 07:20:35 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:38893 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfK0MUf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Nov 2019 07:20:35 -0500
Received: by mail-wr1-f54.google.com with SMTP id i12so26497173wro.5
        for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2019 04:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=inogs-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=DGouXSiP1OMzN6pq8wPjYP/b1a74ooZWBaYO9gvLdU0=;
        b=TJDAWQdQTDTRpaEpTH0rQZ0JkZLixMr2js2hSunbMgYJv3EtW8/eLgBd7H7UHFnqBE
         W2p3gZyPOHgJIrn6ENXMdYAHvwRmGvo1n7iQm8K2I+f7eQx7mR6/GsMxAx/7oedsxzJm
         MYU+lYDUvK62x60TRCiYlogjKR5zTgSsImPbllLF0OlVuM6uY1AfZ/4udCr1ljmuXbSL
         yu1CzvkIKa4OGSKFUHEKsoHZG5zU8bw5YG7xLKN6WmqVQsnwl602SSp2N7JBSxId0yj/
         b1y3hLrbRoLV/s5OPbkkfoo96vkr2YjaTh6wVKoB0n3C0Zjbfit0qyewvTtdnxHVsqvA
         Nkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=DGouXSiP1OMzN6pq8wPjYP/b1a74ooZWBaYO9gvLdU0=;
        b=rWWWMw0o8ElRiwXkQfZNJndclwGNzUHJiJ5ZOc1aLHGyvjGOeI1dUyPMqIzU3Vujga
         zDC61YykyiH5VaugBCi1qUevo1FPwLsG6ksWucdqE5TJavgoJ/+0FFenYd6jvrJ27Ksi
         tPWiQCSKTAVtge5cI3LjKE3kGAP5idqE52HSiu8KYuuA/irkd4ixs9yxXCrCQMMokfdF
         mMs1nV6dRdqOnCAm9ozPyC1gFt7iBoj+Fi1rwZXqEuYG+SAeO1NAwCbKYsuXICY6qcv+
         weWcfdash5ClkWpDmJ3D9leAnNEYWyswRjUPQKZdSd8RDmcwOgsI+TvXHkOUrrOGliYt
         gLTA==
X-Gm-Message-State: APjAAAVxK61kEX2LDpPtqYx71j5Ya2WwiquXOMfu5tC70ebf2ck4XAww
        MqDmksWQD4YCl5qhATzfP3JrpH/qnA2ZqD/RjiIVB59abKjee5TG66nnwn0fQXgdFeOo7PFaET/
        yNHMDF0qvZNaaG4eF7nRscsvIvRoI+sr0oHMqPfJu8sfo54hywzMopEDw4zDqDC1Ke12c63iu
X-Google-Smtp-Source: APXvYqxf3xOGEhlYwTAw8/bVEQoXZ0ZZci7vG62ECDvIW2UFTbMTE6iCO7S2gchKFuZX6+j0z5s7Jw==
X-Received: by 2002:a5d:4608:: with SMTP id t8mr8292748wrq.91.1574857232925;
        Wed, 27 Nov 2019 04:20:32 -0800 (PST)
Received: from deimos.ogs.trieste.it (deimos.ogs.trieste.it. [140.105.70.97])
        by smtp.gmail.com with ESMTPSA id z7sm6484452wma.46.2019.11.27.04.20.32
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 04:20:32 -0800 (PST)
Message-ID: <5a987faff74646e68207e26e570a708669dd4103.camel@inogs.it>
Subject: Permission denied mounting a DFS share with multiuser options
From:   abrosich@inogs.it
To:     linux-cifs@vger.kernel.org
Date:   Wed, 27 Nov 2019 13:20:31 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hello,

I'm trying to configure a linux client (Unubtu 18.04.3) to mount a DFS
share from a windows server 2019. Both machines are joined in the same
Active Directory domain. I joined the linux client using the "realm"
command and it works fine: for example I can login with ssh using AD
credentials.

The package cifs-utils is version 6.8.

I start by saying that I have a little konwledge of the windows world
and in particular of SMB, hence my question could by silly but I
searched for days without find any solution.

I found the following entries in the krb5.conf file (I suppose added by
"realm" coomand): 
3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (des-cbc-crc) 
   3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (des-cbc-md5) 
   3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (arcfour-hmac) 
   3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (aes128-cts-hmac-
sha1-96) 
   3 11/11/19 08:54:09 host/LINUXCLIENT@AD.DOMAIN (aes256-cts-hmac-
sha1-96) 
   3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (des-cbc-crc) 
   3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (des-cbc-md5) 
   3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (arcfour-hmac) 
   3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (aes128-cts-hmac-
sha1-96) 
   3 11/11/19 08:54:09 host/linuxclient@AD.DOMAIN (aes256-cts-hmac-
sha1-96) 

I created on the Domain Controller a user principal "linuxclientuser-
cifs" and associated to it an SPN "cifs/linuxclient.fqdn@AD.DOMAIN". I
exported the keytab file and added it in krb5.keytab where I have now
the followind entries:

  3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (des-cbc-crc) 
   3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (des-cbc-md5) 
   3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (arcfour-hmac) 
   3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (aes256-cts-
hmac-sha1-96) 
   3 11/12/19 12:50:59 cifs/linuxclient.fqdn@AD.DOMAIN (aes128-cts-
hmac-sha1-96) 


I use the following command to mount the share:
sudo mount --verbose --types cifs //winsrv/CifsShare /mnt/cifs --
options
sec=krb5,multiuser,vers=3,user=cifs/linuxclient.fqdn,domain=AD.DOMAIN

and the response is: "mount error(13): Permission denied"

Looking at logs I find:
Nov 27 13:07:18 linuxclient cifs.upcall: key description:
cifs.spnego;0;0;39010000;ver=0x2;host=winsrv;ip4=XXX.XXX.XXX.XXX;sec=kr
b5;uid=0x0;creduid=0x0;user=cifs/linuxclient.fqdn;pid=0x6ac
Nov 27 13:07:18 linuxclient cifs.upcall: ver=2
Nov 27 13:07:18 linuxclient cifs.upcall: host=winsrv
Nov 27 13:07:18 linuxclient cifs.upcall: ip=XXX.XXX.XXX.XXX
Nov 27 13:07:18 linuxclient cifs.upcall: sec=1
Nov 27 13:07:18 linuxclient cifs.upcall: uid=0
Nov 27 13:07:18 linuxclient cifs.upcall: creduid=0
Nov 27 13:07:18 linuxclient cifs.upcall: user=cifs/linuxclient.fqdn
Nov 27 13:07:18 linuxclient cifs.upcall: pid=1708
Nov 27 13:07:18 linuxclient cifs.upcall:
get_cachename_from_process_env: pid == 0
Nov 27 13:07:18 linuxclient cifs.upcall: get_existing_cc: default
ccache is FILE:/tmp/krb5cc_0
Nov 27 13:07:18 linuxclient cifs.upcall: get_tgt_time: unable to get
principal
Nov 27 13:07:18 linuxclient cifs.upcall: handle_krb5_mech: getting
service ticket for winsrv
Nov 27 13:07:18 linuxclient cifs.upcall: handle_krb5_mech: obtained
service ticket
Nov 27 13:07:18 linuxclient cifs.upcall: Exit status 0


where it says that it get the service ticket (I can see it sniffing
packets with wireshark) but it is "unable to get principal". Which
principal?

On the server side I have the following error:

A process has requested access to an object, but has not been granted
those access rights. (0xC0000022)
SPN: session setup failed before the SPN could be queried
SPN Validation Policy: SPN optional / no validation


What I'm doing wrong?

Any suggest is welcome.

Best regards

Alberto


