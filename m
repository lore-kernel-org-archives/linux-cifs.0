From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 10/10] cifs: add mount option to enable local caching
Date: Wed, 23 Jun 2010 18:08:34 +0100
Message-ID: <9942.1277312914@redhat.com>
References: <1277220309-3757-1-git-send-email-sjayaraman@suse.de> <yes>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277220309-3757-1-git-send-email-sjayaraman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> Add a mount option 'fsc' to enable local caching on CIFS.
> 
> As the cifs-utils (userspace) changes are not done yet, this patch enables
> 'fsc' by default to assist testing.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>

Acked-by: David Howells <dhowells@redhat.com>

(Give or take the debugging bit)
