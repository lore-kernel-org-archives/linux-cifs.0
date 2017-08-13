From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [[PATCH v1] 00/37] Implement SMBD protocol: Series 1
Date: Sun, 13 Aug 2017 03:27:35 -0700
Message-ID: <20170813102735.GI17287@infradead.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>
To: Long Li <longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Long,

a few meta-comments:

first the split into lots of tiny lists makes the series really hard
to read, I'd split it into just a few:

 Patch 1: add the protocol constants
 Patch 2-n: core cifs modifcation required to implement SMBD
 Patch n+1: add the actual SMBD code
 Patch n+2..m: write up the core CIFS code to use it.

stcond a lot of the code doesn't seem to follow the usual Linux style.
It might be a good idea to run it through scripts/checkpach.pl and
at least fix the errors it generates.  The warnings are much more
opinioned so feel free to ignore them if they sound odd for now.
