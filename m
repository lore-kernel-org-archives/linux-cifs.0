From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] smb2: fix uninitialized variable bug in
 smb2_ioctl_query_info
Date: Tue, 9 Oct 2018 22:11:42 +0200
Message-ID: <0032cd15-2223-bd5f-3b5f-cf66e1c47275@embeddedor.com>
References: <20181009200719.GA19561@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009200719.GA19561@embeddedor.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



On 10/9/18 10:07 PM, Gustavo A. R. Silva wrote:
> There is a potential execution path in which variable *resp_buftype*
> is passed as an argument to function free_rsp_buf(), in which is used
> without being properly initialized previously.
> 
> Fix this by initializing variable *resp_buftype* to -1 in order to
> avoid unpredictable or unintended results.
> 
> Addresses-Coverity-ID: 1472116 ("Uninitialized scalar variable")
> Fixes: 1473971 ("Uninitialized scalar variable")

ugh... sorry, the line above is wrong... I'll send v2 shotly.

Thanks
--
Gustavo
