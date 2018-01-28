From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH stable] cifs: empty TargetInfo leads to crash on recovery
Date: Sun, 28 Jan 2018 15:43:48 +0100
Message-ID: <20180128144348.GA19937@kroah.com>
References: <20180127200741.57298-1-dan@kernelim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        stable@vger.kernel.org, linux-cifs@vger.kernel.org
To: Dan Aloni <dan@kernelim.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180127200741.57298-1-dan@kernelim.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Jan 27, 2018 at 10:07:41PM +0200, Dan Aloni wrote:
> commit cabfb3680f78 upstream.

Are you sure?
$ gsr cabfb3680f78
cabfb3680f78 ("CIFS: Enable encryption during session setup phase")

Doesn't seem to match up at all here :(

totally confused,

greg k-h
