Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165F0C74A5B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 08:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjCQI4u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 04:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjCQI4r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 04:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4C765C46;
        Fri, 17 Mar 2023 01:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C12DB824F4;
        Fri, 17 Mar 2023 08:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D103AC433EF;
        Fri, 17 Mar 2023 08:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679043361;
        bh=Gio1GUXXQujGj5kXLT+lgayppKbjCJJ2ylmSUsEZdb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sbwT+Sgw6SB4naNHeDAUcthAaEz5V+jqBQsQ2UfcFEUZ8kTffhqQeerIuSg10asya
         8OKN4CMWuq8vRO6HC7J74u+DLC2SIs6yrvgSF+wQTLQmqt/cI3dVpSy3m1UqjJt00j
         iUW4ajPPnaGeEouPeTAWrqwgq65bwP0x2pvrbFfOCH5kS9Yjp0qPh6HXRUmlz5sJSX
         RZfeZd/Oh44KT1mQcYEut97rHfV6YXVz+y+eevqfPBpE9lrbhxhD9RWKKKo1WOF5fN
         Kbc/Tinp4gptC9YxWtkWxRImS5dn6vFmMFsKYRx2tBJ5kZCzoaQDqT80czd/dYb1pv
         QjSVVrsb178fg==
Date:   Fri, 17 Mar 2023 09:55:56 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com
Subject: Re: [PATCH v8 1/3] ksmbd: remove internal.h include
Message-ID: <20230317085556.sprbco6yrd2d2jf2@wittgenstein>
References: <20230315223435.5139-1-linkinjeon@kernel.org>
 <20230315223435.5139-2-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230315223435.5139-2-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Mar 16, 2023 at 07:34:33AM +0900, Namjae Jeon wrote:
> Since vfs_path_lookup is exported, It should not be internal.
> Move vfs_path_lookup prototype in internal.h to linux/namei.h.
> 
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>
