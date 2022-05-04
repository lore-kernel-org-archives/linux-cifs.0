Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08511C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  4 May 2022 19:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbiEDTTV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 May 2022 15:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377580AbiEDTTC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 May 2022 15:19:02 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926B8E00;
        Wed,  4 May 2022 12:15:14 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id DF7CD7FC20;
        Wed,  4 May 2022 19:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1651691712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BaJ2h06KXXGcmCiOujWVj9YsqY+gCox03xbwF+J59pk=;
        b=aFCYhP+cswBxx9JoRDFisVOh3HsxN4wUo/VKuW+Yng7YEN+XsdcgLKTmNIBO2zieKZbcbC
        mt0kau+5Iaq75X02EZvR6vd9chC4qLhNoKXDYUyOGxwMGDVE/ttee8Z5fOHcQrUFoYOUyk
        Ni5Tof75kkDkYAGdh4NmK0VxSy9w7stDWFugwsldDy0+WZZPJ1Q34LLxiISn45AlkzwLh6
        dWFyXLllJGvufmPuaaj0GSHLzPt4y2vyii3BPkzt0BroBBOifDZ97odTm0JYe6jhPAu69E
        jbK8uFIqVQHjPx4DxVsyBj90LusObpkihxl9qpKI98CbKtT12A1wi1yiwlZo3w==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steven French <sfrench@samba.org>,
        Byron Stanoszek <gandalf@winds.org>,
        Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: CIFS regression mounting vers=1.0 NTLMSSP when hostname is too
 long
In-Reply-To: <7dc6c729-73cd-74be-eec7-ac4a0013f60f@samba.org>
References: <e6837098-15d9-acb6-7e34-1923cf8c6fe1@winds.org>
 <878rri2i6o.fsf@cjr.nz> <7dc6c729-73cd-74be-eec7-ac4a0013f60f@samba.org>
Date:   Wed, 04 May 2022 16:15:07 -0300
Message-ID: <87tua51550.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Steven French <sfrench@samba.org> writes:

> makes sense - do you see anything related in the NTLMSSP doc?

I'll quote some relevant parts from MS-NLMP which make sense to me:

	3.1.5.1.2 Client Receives a CHALLENGE_MESSAGE from the Server
	...
	If the NTLMSSP_NEGOTIATE_VERSION flag is set by the client application,
	the Version field MUST be set to the current version (section 2.2.2.10),
	and the Workstation field MUST be set to NbMachineName.
	
	3.2.1.1 Variables Internal to the Protocol
	...
	NbMachineName: A string that indicates the NetBIOS machine name of the
	server.
	
	2.2.2.1 AV_PAIR
	...
	MsvAvNbComputerName: The server's NetBIOS computer name. The name MUST
	be in Unicode, and is not null-terminated. This type of information MUST
	be present in the AV_pair list.

and indeed we set NTLMSSP_NEGOTIATE_VERSION in
fs/cifs/sess.c:build_ntlmssp_smb3_negotiate_blob().

Unless I didn't miss anything obvious, I think we should be sending
NetBIOS name or simply truncate utsname()->nodename to 16 bytes as
previously proposed by Byron regardless what protocol version is being
used.

Tom, what is your opinion on that?
