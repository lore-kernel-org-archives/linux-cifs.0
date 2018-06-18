From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [smb3] unreachable code and memory leaks
Date: Mon, 18 Jun 2018 12:34:39 -0500
Message-ID: <c447e18b-439d-f125-f74c-9c50a0d55e5b@embeddedor.com>
References: <20180618130737.GA13880@embeddedor.com>
 <CAH2r5muZJkx0eR0uAyuRBkkTf7-97x5oSMWPXdfb1TUK4rwGJw@mail.gmail.com>
 <CAH2r5mvu7e2ec6fb0Aay5OAr8S31jy=j7_7sL_VRfi6U2G_mZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mvu7e2ec6fb0Aay5OAr8S31jy=j7_7sL_VRfi6U2G_mZA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hey Steve,

On 06/18/2018 12:18 PM, Steve French wrote:
> Gustavo,
> Thx for pointing this out.  Let me know if this patch addresses what
> you found.  Code is experimental mount option but extremely important
> to get right due to move away from SMB1/CIFS which had posix
> extensions.
> 

Yep. It seems correct.

Reviewed-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Thanks!
--
Gustavo
